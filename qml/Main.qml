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
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import io.thp.pyotherside 1.4


ApplicationWindow {
    visible: true
    width: Screen.width
    height: Screen.height
    title: "Timesheets"

    property var optionList: []
    property var tasksList: []
    property int elapsedTime: 0
    property bool running: false
    property string selected_username: ""
    property bool isTimesheetSaved: false
    property bool isTimesheetClicked: false

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));
            importModule_sync("backend");
        }

        onError: {
            console.log('Python error: ' + traceback);
        }
    }

    Timer {
        id: stopwatchTimer
        interval: 1000  // 1 second
        repeat: true
        onTriggered: {
            elapsedTime += 1
        }
    }

    function formatTime(seconds) {
        var minutes = Math.floor(seconds / 60);
        var secs = seconds % 60;
        return (minutes < 10 ? "0" + minutes : minutes) + ":" +
               (secs < 10 ? "0" + secs : secs);
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: loginPage

        // Login page
        Component {
            id: loginPage
            Item {
                Login {
                    anchors.centerIn: parent
                    onLoggedIn: {
                        selected_username = username;
                        stackView.push(listPage);
                    }
                }
            }
        }

        Component {
            id: manageAccounts
            Rectangle {
                width: parent.width
                height: parent.height
                // color: "#ffffff"
                Column {
                    spacing: 0
                    anchors.fill: parent
                    Rectangle {
                        width: parent.width
                        height: 100
                        color: "#121944"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Rectangle {
                            width: parent.width
                            height: 100
                            color: "#121944"
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            Image {
                                id: logo
                                source: "images/small_logo_blank.png" // Path to your logo image
                                width: 100 // Width of the logo
                                height: 100 // Height of the logo
                                anchors.top: parent.top
                            }
                        }
                        Text {
                            text: "Manage Accounts"
                            anchors.centerIn: parent
                            font.pixelSize: 40
                            color: "#ffffff"
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 80
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 130
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Label {
                        font.bold: true
                        font.pixelSize: 50
                        text: "This page is under development"
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 80
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 200
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Label {
                        font.pixelSize: 40
                        text: "Agenda of this page is to work with multiple accounts \nwithout logging out, and provide facility to switching \naccounts."
                    }
                }
                Rectangle {
                    width: parent.width
                    height: 80
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 400
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Button {
                        id: backButton
                        width: 150
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

                        // Show/hide the menu on click
                        onClicked: stackView.push(listPage)
                    }
                }
            }

        }

        Component {
            id: storedTimesheets
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                Column {
                    spacing: 0
                    anchors.fill: parent
                    Rectangle {
                        width: parent.width
                        height: 100
                        color: "#121944"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Rectangle {
                            width: parent.width
                            height: 100
                            color: "#121944"
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            Image {
                                id: logo
                                source: "images/small_logo_blank.png" // Path to your logo image
                                width: 100 // Width of the logo
                                height: 100 // Height of the logo
                                anchors.top: parent.top
                            }
                        }
                        Text {
                            text: "Stored Timesheet"
                            anchors.centerIn: parent
                            font.pixelSize: 40
                            color: "#ffffff"
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 80
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 130
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Label {
                        font.bold: true
                        font.pixelSize: 50
                        text: "This page is under development"
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 80
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 200
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Label {
                        font.pixelSize: 40
                        text: "Agenda of this page is to see existing timesheet entries\n which are remaining to be synchronized with Odoo and\nability to sync all entries account wise."
                    }
                }
                Rectangle {
                    width: parent.width
                    height: 80
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 400
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Button {
                        id: backButton
                        width: 150
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

                        // Show/hide the menu on click
                        onClicked: stackView.push(listPage)
                    }
                }
            }

        }

        Component {
            id: listPage
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                Column {
                    spacing: 0
                    anchors.fill: parent
                    Rectangle {
                        width: parent.width
                        height: 100
                        color: "#121944"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Rectangle {
                            width: parent.width
                            height: 100
                            color: "#121944"
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            Image {
                                id: logo
                                source: "images/small_logo_blank.png" // Path to your logo image
                                width: 100 // Width of the logo
                                height: 100 // Height of the logo
                                anchors.top: parent.top
                            }
                        }
                        Text {
                            text: "Timesheet"
                            anchors.centerIn: parent
                            font.pixelSize: 40
                            color: "#ffffff"
                        }
                        Rectangle {
                            width: parent.width
                            height: 100
                            color: "transparent"
                            anchors.top: parent.top
                            anchors.right: parent.right

                            // Hamburger Icon
                            Button {
                                id: hamburgerButton
                                width: 100
                                height: 100
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.topMargin: 20
                                anchors.verticalCenter: parent.verticalCenter

                                // Display hamburger icon (three lines)
                                background: Rectangle {
                                    color: "#121944"
                                    border.color: "#121944" // Ensure no border is visible
                                }

                                // Hamburger Icon
                                Label {
                                    text: "☰"
                                    font.pixelSize: 40
                                    color: "#fff" // Set the hamburger icon color to white
                                    anchors.centerIn: parent
                                }

                                // Show/hide the menu on click
                                onClicked: hamburgerButtonmenu.open()
                            }

                            

                            // Dropdown Menu
                            Menu {
                                id: hamburgerButtonmenu
                                x: hamburgerButton.x
                                y: hamburgerButton.y + hamburgerButton.height
                                width: 400
                                height: 250
                                background: Rectangle {
                                    color: "#121944" // Background color of the MenuItem
                                    radius: 4
                                    border.color: "transparent" // Optional: remove border if needed
                                }

                                MenuItem {
                                    width: parent.width
                                    height: 70
                                    // color: "#121944"
                                    background: Rectangle {
                                        color: "#121944" // Background color of the MenuItem
                                        radius: 4
                                        border.color: "#121944" // Optional: remove border if needed
                                    }

                                    Text {
                                        text: "MANAGE ACCOUNTS"
                                        font.pixelSize: 30
                                        anchors.centerIn: parent
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "#fff"
                                    }
                                    // text: 
                                    onClicked: {
                                        stackView.push(manageAccounts);
                                    }
                                }

                                MenuItem {
                                    width: parent.width
                                    height: 70
                                    // color: "#121944"
                                    background: Rectangle {
                                        color: "#121944" // Background color of the MenuItem
                                        radius: 4
                                        border.color: "#121944" // Optional: remove border if needed
                                    }

                                    Text {
                                        text: "TIMESHEETS"
                                        font.pixelSize: 30
                                        anchors.centerIn: parent
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "#fff"
                                    }
                                    // text: 
                                    onClicked: {
                                        stackView.push(storedTimesheets);
                                    }
                                }

                                MenuItem {
                                    width: parent.width
                                    height: 70
                                    // color: "#121944"
                                    background: Rectangle {
                                        color: "#121944" // Background color of the MenuItem
                                        radius: 4
                                        border.color: "#121944" // Optional: remove border if needed
                                    }

                                    Text {
                                        text: "LOG OUT"
                                        font.pixelSize: 30
                                        anchors.centerIn: parent
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "#fff"
                                    }
                                    // text: 
                                    onClicked: {
                                        // Add logout logic here
                                        console.log("Logging out...")
                                        python.call("backend.logout", {} , function(result) {
                                            // optionList = result;
                                            // menu.open(); // Open the menu after fetching options
                                            stackView.push(loginPage)
                                        });
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 80
                        // color: "#121944"
                        anchors.topMargin: 120
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Text {
                            text: "Hello," + selected_username
                            anchors.centerIn: parent
                            font.pixelSize: 40
                            color: "#000"
                        }
                    }

                    Item {
                        height: parent.height
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 300
                        anchors.top: parent.top
                        anchors.leftMargin: 30

                        Row {
                            spacing: 200
                            // anchors.centerIn: parent
                            anchors.verticalCenterOffset: -height * 1.5

                            Column {
                                spacing: 40
                                width: 60
                                Label { text: "Date" 
                                    width: 150
                                    height: 80}
                                Label { text: "Project" 
                                width: 150
                                height: 80}
                                Label { text: "Task" 
                                width: 150
                                height: 80}
                                Label { text: "Description" 
                                width: 150
                                height: 80}
                                Label { text: "Spent Hours" 
                                width: 150
                                height: 80}
                            }
                            Column {
                                spacing: 40
                                width: 350
                                Rectangle {
                                    width: 750
                                    height: 80
                                    color: "transparent"

                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: "black"
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                    }
                                    TextInput {
                                        width: parent.width
                                        height: parent.height
                                        font.pixelSize: 50
                                        anchors.fill: parent
                                        id: datetimeInput
                                        Text {
                                            id: datetimeplaceholder
                                            text: "Date"
                                            font.pixelSize: 30
                                            color: "#aaa"
                                            anchors.fill: parent
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        Dialog {
                                            id: calendarDialog
                                            width: 700
                                            height: 650
                                            padding: 0
                                            margins: 0
                                            visible: false

                                            DatePicker {
                                                id: datePicker
                                                onClicked: {
                                                    datetimeInput.text = Qt.formatDate(date, 'M/d/yyyy').toString()
                                                }
                                            }
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                var now = new Date()
                                                datePicker.selectedDate = now
                                                datePicker.currentIndex = now.getMonth()
                                                datePicker.selectedYear = now.getFullYear()
                                                calendarDialog.visible = true
                                            }
                                        }

                                        onTextChanged: {
                                            if (datetimeInput.text.length > 0) {
                                                datetimeplaceholder.visible = false
                                            } else {
                                                datetimeplaceholder.visible = true
                                            }
                                        }
                                        function formatDate(date) {
                                            var month = date.getMonth() + 1; // Months are 0-based
                                            var day = date.getDate();
                                            var year = date.getFullYear();
                                            return month + '/' + day + '/' + year;
                                        }

                                        // Set the current date when the component is completed
                                        Component.onCompleted: {
                                            var currentDate = new Date();
                                            datetimeInput.text = formatDate(currentDate);
                                        }

                                    }
                                }
                                Rectangle {
                                    width: 750
                                    height: 80
                                    color: "transparent"

                                    // Border at the bottom
                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: "black"  // Border color
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                    }
                                    TextInput {
                                        width: parent.width
                                        height: parent.height
                                        font.pixelSize: 40
                                        anchors.fill: parent
                                        //anchors.margins: 5                                                        
                                        id: projectInput
                                        Text {
                                            id: projectplaceholder
                                            text: "Project"                                            
                                            font.pixelSize:40
                                            color: "#aaa"
                                            anchors.fill: parent
                                            verticalAlignment: Text.AlignVCenter
                                            
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                python.call("backend.fetch_options", {} , function(result) {
                                                    optionList = result;
                                                    menu.open(); // Open the menu after fetching options
                                                });

                                            }
                                        }

                                        Menu {
                                            id: menu
                                            x: projectInput.x
                                            y: projectInput.y + projectInput.height
                                            width: projectInput.width  // Match width with TextField


                                            Repeater {
                                                model: optionList

                                                MenuItem {
                                                    width: parent.width
                                                    height: 80
                                                    Text {
                                                        text: modelData
                                                        font.pixelSize: 40
                                                        bottomPadding: 5
                                                        topPadding: 5
                                                        //anchors.centerIn: parent
                                                        color: "#000"
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 10                                                 
                                                        wrapMode: Text.WordWrap
                                                        elide: Text.ElideRight   
                                                        maximumLineCount: 2      
                                                    }

                                                    onClicked: {
                                                        projectInput.text = modelData

                                                        menu.close()
                                                    }
                                                }
                                            }
                                        }

                                        onTextChanged: {
                                            if (projectInput.text.length > 0) {
                                                projectplaceholder.visible = false
                                            } else {
                                                projectplaceholder.visible = true
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 750
                                    height: 80
                                    color: "transparent"

                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: "black"
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                    }
                                    TextInput {
                                        width: parent.width
                                        height: parent.height
                                        font.pixelSize: 40
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        id: taskInput
                                        // text: gridModel.get(index).task
                                        Text {
                                            id: taskplaceholder
                                            text: "Task"
                                            color: "#aaa"
                                            font.pixelSize: 40                                        
                                            anchors.fill: parent
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                python.call("backend.fetch_options_tasks", [projectInput.text] , function(result) {
                                                    tasksList = result;
                                                    menuTasks.open(); // Open the menu after fetching options
                                                });

                                            }
                                        }

                                        Menu {
                                            id: menuTasks
                                            x: taskInput.x
                                            y: taskInput.y + taskInput.height
                                            width: taskInput.width

                                            Repeater {
                                                model: tasksList

                                                MenuItem {
                                                    width: parent.width
                                                    height: 80
                                                    Text {
                                                        text: modelData
                                                        font.pixelSize: 40
                                                        bottomPadding: 5
                                                        topPadding: 5                                                    
                                                        color: "#000"
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 10                                                 
                                                        wrapMode: Text.WordWrap
                                                        elide: Text.ElideRight   
                                                        maximumLineCount: 2  
                                                    }
                                                    onClicked: {
                                                        taskInput.text = modelData
                                                        menu.close()
                                                    }
                                                }
                                            }
                                        }

                                        onTextChanged: {
                                            if (taskInput.text.length > 0) {
                                                taskplaceholder.visible = false
                                            } else {
                                                taskplaceholder.visible = true
                                            }
                                        }
                                    }
                                }


                                Rectangle {
                                    width: 750
                                    height: 80

                                    color: "transparent"

                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: "black"
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                    }
                                    TextInput {
                                        width: parent.width
                                        height: parent.height
                                        font.pixelSize: 40
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        id: descriptionInput
                                        // text: gridModel.get(index).task
                                        Text {
                                            id: descriptionplaceholder
                                            text: "Description"
                                            color: "#aaa"
                                            font.pixelSize: 30
                                            anchors.fill: parent
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onTextChanged: {
                                            if (descriptionInput.text.length > 0) {
                                                descriptionplaceholder.visible = false
                                            } else {
                                                descriptionplaceholder.visible = true
                                            }
                                        }
                                    }
                                }

                                TextInput {
                                    width: 300
                                    height: 50
                                    font.pixelSize: 50
                                    id: spenthoursInput
                                    text: formatTime(elapsedTime)
                                    validator: RegExpValidator { regExp: /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/ }
                                }
                                Row {
                                    spacing: 10
                                    Button {
                                        background: Rectangle {
                                            color: running ? "lightcoral" : "lightgreen"
                                            radius: 10
                                            border.color: running ? "red" : "green"
                                            border.width: 2
                                        }

                                        contentItem: Text {
                                            text: running ? "Stop" : "Start"
                                            color: running ? "darkred" : "darkgreen"
                                            font.pixelSize: 30
                                        }

                                        onClicked: {
                                            if (running) {
                                                stopwatchTimer.stop();
                                            } else {
                                                stopwatchTimer.start();
                                            }
                                            running = !running;
                                        }
                                    }

                                    Button {

                                        background: Rectangle {
                                            color: "#121944"
                                            radius: 10
                                            border.color: "#87ceeb"
                                            border.width: 2
                                        }

                                        contentItem: Text {
                                            text: "Reset"
                                            color: "#ffffff"
                                            font.pixelSize: 30
                                        }


                                        text: "Reset"
                                        onClicked: {
                                            stopwatchTimer.stop();
                                            elapsedTime = 0;
                                            running = false;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 80
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: 1000
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        Button {
                            width: 680
                            height: 90
                            anchors.centerIn: parent
                            background: Rectangle {
                                color: "#121944"
                                radius: 10
                                border.color: "#87ceeb"
                                border.width: 2
                                anchors.fill: parent
                            }

                            contentItem: Text {
                                text: "         Save Timesheet"
                                color: "#ffffff"
                                font.pixelSize: 40
                            }

                            Timer {
                                id: typingTimer
                                interval: 1500 // Time in milliseconds (1.5 second)
                                running: false
                                repeat: false
                                onTriggered: {
                                    if (isTimesheetSaved) {
                                        isTimesheetClicked = false;
                                        isTimesheetSaved = false;
                                        projectInput.text = "";
                                        taskInput.text = "";
                                        descriptionInput.text = "";
                                        elapsedTime = 0;
                                    }
                                }
                            }

                            onClicked: {
                                var dataArray = [];
                                
                                var dataObject = {
                                    dateTime: datetimeInput.text,
                                    project: projectInput.text,
                                    task: taskInput.text,
                                    description: descriptionInput.text,
                                    spenthours: spenthoursInput.text
                                };
                                dataArray.push(dataObject);

                                python.call("backend.save_timesheet_entries", [JSON.stringify(dataArray)], function (result) {
                                    isTimesheetClicked = true;
                                    if (result && result !== undefined) {
                                        isTimesheetSaved = true;
                                        typingTimer.start()
                                    }
                                })
                            }
                        }
                    }
                    Rectangle {
                        width: parent.width
                        height: 80
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: 1100
                        anchors.leftMargin: 250
                        anchors.right: parent.right
                        Text {
                            id: timesheedSavedMessage
                            text: isTimesheetSaved ? "Timesheet is Saved successfully!" : "Timesheet could not be saved!"
                            color: isTimesheetSaved ? "green" : "red"
                            visible: isTimesheetClicked
                            font.pixelSize: 40
                        }
                    }
                }
            }
        }
    }
}
