import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Window {
    visible: true
    width: 800
    height: 540
    title: qsTr("学生管理")
    StackView{
       id:stack
       initialItem: msnDelegate
       anchors.fill: parent
    }

    ListView {
        id:listview
        width: parent.width
        height: parent.height
        anchors.bottom: toolBar.top
        topMargin: 150
        ScrollBar.vertical: ScrollBar {
            id: vBar
            policy: ScrollBar.AsNeeded
            active: vBar.active
        }
        snapMode: ListView.SnapOneItem
        model: myModel
        delegate: msnDelegate
        highlightFollowsCurrentItem: true   //highlight被view管理
        highlight: Rectangle { color: "lightsteelblue"; radius: 5}
        highlightMoveVelocity: 800
        currentIndex: 0
        header: headerRec
        footer: toolBar
        interactive: true   //拖动
    }

    Component{
        id: msnDelegate
        Item{
            id: wrapper
            width: 800
            height: 40
            RowLayout{
                spacing: 20
                Text { text: id;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 40}
                Text { text: name;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 60}
                Text { text: gender;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 50}
                Text { text: age;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 50}
                Text { text: birthday;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 90}
                Text { text: address;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 60}
                Text { text: start_time;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 90}
                Text { text: major;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 60}
                Text { text: classes;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 60}
                Text { text: credit;color: wrapper.ListView.isCurrentItem ? "red" : "#000000" ;Layout.preferredWidth: 50}
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    wrapper.ListView.view.currentIndex = index
                    var data=listview.model.getData(listview.currentIndex)
                    console.log("[",String(data),"]")
                }
            }
        }
    }

    Rectangle{
        id: headerRec
        width: parent.width
        height: 10
        Row{
            Text {
                text: qsTr("ID")
                width:60
            }
            Text {
                text: qsTr("姓名")
                width: 75
            }
            Text {
                text: qsTr("性别")
                width: 70
            }
            Text {
                text: qsTr("年龄")
                width:75
            }
            Text {
                text: qsTr("出生日期")
                width: 100
            }
            Text {
                text: qsTr("家庭住址")
                width: 90
            }
            Text {
                text: qsTr("入学时间")
                width: 110
            }
            Text {
                text: qsTr("专业")
                width: 80
            }
            Text {
                text: qsTr("班级")
                width: 80
            }
            Text {
                text: qsTr("学分")
            }
        }
    }
    RowLayout{
            id:toolBar
            width: parent.width
            height: 100
            spacing: 100
            anchors{
                bottom:parent.bottom
                topMargin: 100
            }
            Button{
                id:insBT
                text:"添加"
                Layout.preferredHeight: 50
                Layout.preferredWidth: 100
            }

            Button{
                text:"删除选择项"
                Layout.preferredHeight: 50
                Layout.preferredWidth: 100
                onClicked: {
                    myModel.delCurIndexData(listview.currentIndex)
                }
            }
            Rectangle{
                id:recBT
                Layout.preferredHeight: 50
                Layout.preferredWidth: 100
                Button{
                    id: bt1
                    text: "清空"
                    width: 50
                    height: 50
                    anchors.right: bt2.left
                }
                Button{
                    id: bt2
                    text: "test"
                    width: 50
                    height: 50
                    anchors.left: bt1.right
                    onClicked: {
                        myModel.testUser()
                    }
                }
            }
            Button{
                id: selectBT
                text:"查询"
                Layout.preferredHeight: 50
                Layout.preferredWidth: 100
            }
        }

//子窗口
//
    Dialog{
        id: emptyDia
        width: 200
        height: 150
        title: "Warning"
        modal: true
        visible: false
        anchors.centerIn: parent
        standardButtons: Dialog.Yes | Dialog.Cancel
        Label{
            text: "确定清空所有数据吗"
        }
        onAccepted: {
            myModel.empty()
        }
    }

    Dialog{
        id: selectDia
        width: 400
        height: 300
        anchors.centerIn: parent
        title: "筛选用户"
        visible: false
        standardButtons: Dialog.Save | Dialog.Cancel |Dialog.Reset
        Rectangle{

            width: parent.width
            height: parent.height
            Row{
                Column{
                    Row{
                        Text {
                            text: qsTr("name:")
                        }
                        TextField{
                            id: sel_name
                        }
                    }
                    Row{
                        Text {
                            text: qsTr("age:")
                        }
                        TextField{
                            id: sel_age_from
                            text: "0"
                        }
                        Text{
                            text: " - "
                        }
                        TextField{
                            id: sel_age_to
                            text: "100"
                        }
                    }
                }
            }
        }
        onAccepted: {
            myModel.sel(sel_name.text,sel_age_from.text,sel_age_to.text);
        }
        onReset: {
            myModel.allUsers()
            selectDia.visible = false
        }
    }

    Dialog{
        id: dia
        width: 400
        title: "添加用户"
        modal: true
        visible: false
        anchors.centerIn: parent
        standardButtons: Dialog.Save | Dialog.Cancel
        Column{
            Column{
                Label{
                    text: "姓名"
                }
                TextField {
                    id: nameField
                }
            }
            Column{
                Label{
                    text: "性别"
                }
                ComboBox{
                    id: gender_field
                    model: ["男","女"]
                }
            }
            Column{
                Label{
                    text: "年龄"
                }
                TextField {
                    id: ageField
                }
            }
            Column{
                Label{
                    text: "出生日期"
                }
                Row{
                    TextField {
                        id: yearField
                        placeholderText: qsTr("year")
                    }
                    ComboBox{
                        id: monthField
                        model: ["1","2","3","4","5","6","7","8","9","10","11","12",]
                    }
                    TextField {
                        id: dayField
                        placeholderText: qsTr("day")
                    }
                }
            }
            Column{
                Label{
                    text: "家庭住址"
                }
                TextField {
                    id: adField
                }
            }
            Column{
                Label{
                    text: "入学时间"
                }
                Row{
                    TextField {
                        id: enrollYearField
                        placeholderText: qsTr("year")
                    }
                    ComboBox{
                        id: enrollMonthField
                        model: ["1","2","3","4","5","6","7","8","9","10","11","12",]
                    }
                    TextField {
                        id: enrollDayField
                        placeholderText: qsTr("day")
                    }
                }
            }
            Column{
                Label{
                    text: "专业"
                }
                TextField {
                    id: majorField
                }
            }
            Column{
                Label{
                    text: "班级"
                }
                TextField {
                    id: classField
                }
            }
            Column{
                Label{
                    text: "学分"
                }
                TextField {
                    id: creditField
                }
            }
        }
        onAccepted:{
            myModel.insertData(nameField.text,gender_field.currentText,ageField.text,adField.text,
                                majorField.text,classField.text,creditField.text);
            myModel.insertNext(yearField.text,monthField.currentText,dayField.text,
                                enrollYearField.text,enrollMonthField.currentText,enrollDayField.text,
                                nameField.text,adField.text);
        }
        onRejected: {
            console.log("Cancel")
        }
    }

    Connections{
        target: insBT
        onClicked:{
            dia.visible = true
        }
    }
    Connections{
        target: bt1
        onClicked:{
            emptyDia.visible = true
        }
    }
    Connections{
        target: selectBT
        onClicked:{
            selectDia.visible = true
        }
    }
}
