# State Management

在 Flutter 中，由於 Widget 是 immutable 的，當狀態改變時，就需要通過 state management 機制來重新建構 Widget tree。常見的 state management 機制包括：

StatefulWidget：通過建立一個可以改變狀態的 State 對象，來管理狀態。
InheritedWidget：在 Widget tree 中傳遞數據，可以方便地實現全局狀態管理。
Provider：是基於 InheritedWidget 實現的一個狀態管理庫，提供了更簡單的 API。
BLoC：通過將業務邏輯和 UI 分離，來管理狀態。

## StatefulWidget

    1. createState
      ```
      class YellowBird extends StatefulWidget {
        const YellowBird({ super.key });
     
        @override
        State<YellowBird> createState() => _YellowBirdState();
      }
     
      class _YellowBirdState extends State<YellowBird> {
        @override
        Widget build(BuildContext context) {
          return Container(color: const Color(0xFFFFE306));
        }
      }
      ```

    2. initState

        a. build
            當發生調用 initState、didChangeDependencies、didUpdateWidget 或調用 setState更改狀態時(也就是重建widget時)，都會調用此方法

        b. didChangeDependencies
            此方法在initState之後以及State對象的依賴關係通過InheritedWidget更改時立即調用

        c. didUpdateWidget
            每當widget configuration更改時，都會調用此方法。
            ex.父級通過構造函數(constructor)將一些variable傳遞給子級widget

        d. deactivate
            當從tree中移除object時調用此方法

        e. dispose
            當object從tree中永久刪除時，將調用此方法。並且釋放該object保留的所有資源

 

