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
import QtQuick.LocalStorage 2.7

Item {
    width: Screen.width
    height: Screen.height
    property var optionList: []
    property bool isTextInputVisible: false
    property bool isTextMenuVisible: false
    property bool isValidUrl: true
    property bool isValidLogin: true
    property bool isValidAccount: true
    property bool isPasswordVisible: false
    property var accountsList: []

    function initializeDatabase() {
        var db = LocalStorage.openDatabaseSync("myDatabase", "1.0", "My Database", 1000000);

        db.transaction(function(tx) {
            // Create a table if it doesn't exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS users (\
                id INTEGER PRIMARY KEY AUTOINCREMENT,\
                name TEXT NOT NULL,\
                link TEXT NOT NULL,\
                database TEXT NOT NULL,\
                username TEXT NOT NULL\
            )');
        });
    }

    function queryData() {
        var db = LocalStorage.openDatabaseSync("myDatabase", "1.0", "My Database", 1000000);

        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM users');
            console.log("Database Query Results:");
            accountsList = [];
            for (var i = 0; i < result.rows.length; i++) {
                accountsList.push({'user_id': result.rows.item(i).id, 'name': result.rows.item(i).name, 'link': result.rows.item(i).link, 'database': result.rows.item(i).database, 'username': result.rows.item(i).username})
            }
            recordModel.clear();
            for (var i = 0; i < accountsList.length; i++) {
                recordModel.append(accountsList[i]);
            }
        });
    }

    function deleteData(recordId) {
        var db = LocalStorage.openDatabaseSync("myDatabase", "1.0", "My Database", 1000000);

        db.transaction(function(tx) {
            var result = tx.executeSql('DELETE FROM users where id =' + parseInt(recordId));
        });
    }

    Rectangle {
        width: Screen.width
        height: Screen.height
        color: "#121944"
        anchors.centerIn: parent

        Image {
            id: logo
            source: "images/timesheets_large_logo.png" // Path to your logo image
            width: 300
            height: 300
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
        }
        Label {
            anchors.top: logo.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: 'Choose an Account'
            font.pixelSize: 60
            color: "#fff"
            id: chooseAccountLabel
            anchors.topMargin: 20
        }

        Rectangle {
            // width: parent.width
            height: 80
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 60
            anchors.leftMargin: 30
            // anchors.right: parent.right
            Button {
                id: backButton
                // width: 150
                height: 130
                anchors.verticalCenter: parent.verticalCenter

                background: Rectangle {
                    color: "#121944"
                    border.color: "#121944"
                }
                // Hamburger Icon
                Label {
                    text: "Back"
                    font.pixelSize: 40
                    color: "#fff"
                    anchors.centerIn: parent
                }
                onClicked: backPage()
            }
            
        }

        Rectangle {
            // width: parent.width
            height: 80
            anchors.top: parent.top
            // anchors.left: parent.left
            anchors.topMargin: 60
            anchors.rightMargin: 200
            anchors.right: parent.right
            Button {
                id: addNewAccountButton
                // width: 150
                height: 130
                anchors.verticalCenter: parent.verticalCenter

                background: Rectangle {
                    color: "#121944"
                    border.color: "#121944"
                }
                // Hamburger Icon
                Label {
                    text: "Add Account"
                    font.pixelSize: 40
                    color: "#fff"
                    anchors.centerIn: parent
                }
                onClicked: goToLogin()
            }
        }

        ListModel {
            id: recordModel
        }

        ListView {
            id: listView
            anchors.fill: parent
            // anchors.margins: 20
            anchors.topMargin: 450
            anchors.centerIn: parent
            anchors.top: chooseAccountLabel.bottom
            model: recordModel
            spacing: 10

            delegate: Item {
                width: parent.width
                height: 200

                Rectangle {
                    width: parent.width - 250 // Adjust width for margins
                    height: 190
                    anchors.centerIn: parent
                    color: "#fff"
                    border.color: "#ccc"
                    radius: 10
                    border.width: 1

                    Row {
                        spacing: 10
                        anchors.fill: parent
                        anchors.margins: 20

                        // Circle with the first character
                        Rectangle {
                            width: 150
                            height: 150
                            color: "#0078d4"
                            radius: 80
                            border.color: "#0056a0"
                            border.width: 2
                            anchors.rightMargin: 10
                            Text {
                                text: model.name[0]
                                color: "#fff"
                                anchors.centerIn: parent
                                font.pixelSize: 40
                            }
                        }

                        // Vertical layout for text and delete icon
                        Column {
                            spacing: 20
                            width: parent.width - 280 // Adjust width to account for the circle and spacing

                            // Name
                            Text {
                                text: model.name
                                font.pixelSize: 40
                                color: "#000"
                                elide: Text.ElideRight
                            }

                            // Link
                            Text {
                                text: model.link
                                font.pixelSize: 30
                                color: "#0078d4"
                                elide: Text.ElideRight
                            }
                        }

                        // Delete icon
                        Button {
                            width: 100
                            height: 100
                            background: Rectangle {
                                color: "transparent"
                                radius: 10
                                border.color: "transparent"
                            }
                            Image {
                                source: "images/delete.png"
                                anchors.fill: parent
                                smooth: true
                            }
                            onClicked: {
                                deleteData(model.user_id)
                                recordModel.remove(index)
                            }
                        }
                    }
                    // MouseArea {
                    //     id: rowMouseArea
                    //     anchors.fill: parent
                    //     onClicked: {
                    //         console.log("Row clicked: " + model.name)
                    //         logInPage(model.username, model.name, model.database, model.link)
                    //     }
                    //     propagateComposedEvents: true
                    // }
                }
            }
        }



    }

    Component.onCompleted: {
        initializeDatabase();
        queryData();
    }

    signal logInPage(string username, string name, string db, string link)
    signal goToLogin()
    signal backPage()
}
