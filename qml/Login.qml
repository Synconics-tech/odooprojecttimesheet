/*
 * Copyright (C) 2024  Synconics Technologies Pvt. Ltd.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * odooprojecttimesheet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

Item {
    width: Screen.width
    height: Screen.height
    property var optionList: []
    property bool isTextInputVisible: false
    property bool isTextMenuVisible: false
    property bool isValidUrl: true
    property bool isValidLogin: true

    // Login form components
    Rectangle {
        width: Screen.width
        height: Screen.height
        color: "#121944"
        anchors.centerIn: parent

        Image {
            id: logo
            source: "images/large_logo_blank.png" // Path to your logo image
            width: 500
            height: 500
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
        }

        Column {
            spacing: 10
            anchors.top: logo.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20

            TextField {
                id: linkInput
                placeholderText: "Link"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 1000

                onEditingFinished: {
                    text = text.toLowerCase();
                    if(isValidURL(linkInput.text)) {
                        isValidUrl = true;
                        python.call("backend.fetch_databases", [linkInput.text], function(result) {
                            isTextInputVisible = result.text_field
                            isTextMenuVisible = result.menu_items
                            if (isTextMenuVisible) {
                                optionList = result.menu_items
                            }
                        });
                    } else {
                        isValidUrl = false;
                    }
                }

                onTextChanged: {
                    text = text.toLowerCase();
                }

                function isValidURL(url) {
                    var pattern = new RegExp('^(https?:\\/\\/)?' + // protocol
                        '(([a-zA-Z0-9\\-\\.]+)\\.([a-zA-Z]{2,4})|' + // domain name
                        '(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})|' + // OR ipv4
                        '\\[([a-fA-F0-9:\\.]+)\\])' + // OR ipv6
                        '(\\:\\d+)?(\\/[-a-zA-Z0-9@:%_\\+.~#?&//=]*)*$', 'i');
                    return pattern.test(url);
                }
            }

            Text {
                id: errorMessage
                text: isValidUrl ? "" : "Please enter a valid URL"
                color: "red"
                visible: !isValidUrl
                font.pixelSize: 40
            }

            TextField {
                id: dbInput
                placeholderText: "Database"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 1000
                visible: isTextInputVisible
            }

            TextField {
                id: dbInputMenu
                placeholderText: "Database"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 1000
                visible: isTextMenuVisible
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // python.call("backend.fetch_options_tasks", [projectInput.text] , function(result) {
                        //     tasksList = result;
                        menuTasks.open(); // Open the menu after fetching options
                        // });

                    }
                }
                Menu {
                    id: menuTasks
                    x: dbInputMenu.x
                    y: dbInputMenu.y
                    width: dbInputMenu.width

                    Repeater {  
                        model: optionList

                        MenuItem {
                            width: parent.width
                            height: 80
                            Text {
                                text: modelData
                                font.pixelSize: 40                    
                                color: "#000"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10                                                 
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight   
                                maximumLineCount: 2 
                            }
                            onClicked: {
                                dbInputMenu.text = modelData
                                menuTasks.close()
                            }
                        }
                    }
                }
            }

            TextField {
                id: usernameInput
                placeholderText: "Username"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 1000
            }

            TextField {
                id: passwordInput
                placeholderText: "Password"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 1000
                echoMode: TextInput.Password
            }

            Button {
                anchors.topMargin: 20
                width: 1000
                // color: "#FB634E"
                background: Rectangle {
                    color: "#FB634E"
                    radius: 10
                    border.color: "#FB634E"
                    // border.width: 2
                }

                contentItem: Text {
                    text: "Login"
                    color: "#ffffff"
                    font.pixelSize: 30

                }
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    python.call("backend.login_odoo", [linkInput.text, usernameInput.text, passwordInput.text, {'input_text': dbInput.text, 'selected_db': dbInputMenu.text, 'isTextInputVisible': isTextInputVisible, 'isTextMenuVisible': isTextMenuVisible}], function (result) {
                        if (result && result['result'] == 'pass') {
                            isValidLogin = true;
                            loggedIn(result['name_of_user']);
                        }
                        else {
                            isValidLogin = false;
                           console.log("Invalid credentials"); 
                        }
                    })
                }
                
            }

            Text {
                id: errorMessageLogin
                text: isValidLogin ? "" : "Please enter valid Credentials!"
                color: "red"
                visible: !isValidLogin
                font.pixelSize: 40
            }
        }
    }

    // Signal emitted upon successful login
    signal loggedIn(string username)
}
