# State Management

在 Flutter 中，由於 Widget 是 immutable 的，當狀態改變時，就需要通過 state management 機制來重新建構 Widget tree。常見的 state
management 機制包括：

StatefulWidget：通過建立一個可以改變狀態的 State 對象，來管理狀態。 InheritedWidget：在 Widget tree 中傳遞數據，可以方便地實現全局狀態管理。
Provider：是基於 InheritedWidget 實現的一個狀態管理庫，提供了更簡單的 API。 BLoC：通過將業務邏輯和 UI 分離，來管理狀態。

## StatefulWidget

1. createState 當 StatefulWidget 被載入時，會調用 createState() 方法創建對應的 State 對象。 以下是官方文件的例子

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

2. initState 當 State 被創建時，會調用 initState() 方法進行初始化的操作，例如初始化狀態（state）、訂閱事件、啟動動畫等。

   a. build 當發生調用 initState、didChangeDependencies、didUpdateWidget 或調用 setState 更改狀態時(也就是重建widget時)
   ，都會調用此方法來構建當前的 Widget Tree

   b. didChangeDependencies 此方法在initState之後以及State對象的依賴關係通過InheritedWidget更改時立即調用

   c. didUpdateWidget 每當widget configuration更改時，都會調用此方法。

   d. deactivate 當 Widget 從樹中被移除時，會調用 deactivate() 方法，通常在這個方法中可以做一些清理工作，比如取消訂閱事件等。

   e. dispose 當object從tree中永久刪除時，將調用此方法。並且釋放該object保留的所有資源


以下是一個範例，在這個範例中，我們在 initState() 中創建了一個 Timer，每秒更新一次 _seconds 變數，並在 dispose() 中取消該 Timer。這樣做可以確保當該 widget 被移除時，計時器也會被正確地停止。
```
   class MyTimerWidget extends StatefulWidget {
      @override
         _MyTimerWidgetState createState() => _MyTimerWidgetState();
      }
   
   class _MyTimerWidgetState extends State<MyTimerWidget> {
      int _seconds = 0;
      late Timer _timer;
      
      @override
      void initState() {
         super.initState();
         _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
               _seconds++;
            });
         });
      }
      
      @override
      void dispose() {
         _timer.cancel();
         super.dispose();
      }
      
      @override
      Widget build(BuildContext context) {
         return Center(
                child: Text('$_seconds seconds'),
         );
      }
   }
   
   ```

 

