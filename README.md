# State Management

在 Flutter 中，由於 Widget 是 immutable 的，當狀態改變時，就需要通過 state management 機制來重新建構 Widget tree。常見的 state
management 機制包括：

StatefulWidget：通過建立一個可以改變狀態的 State 對象，來管理狀態。 InheritedWidget：在 Widget tree 中傳遞數據，可以方便地實現全局狀態管理。
Provider：是基於 InheritedWidget 實現的一個狀態管理庫，提供了更簡單的 API。 BLoC：通過將業務邏輯和 UI 分離，來管理狀態。

## StatefulWidget

1. createState() : 當 StatefulWidget 被載入時，會調用此方法創建對應的 State 對象。 以下是官方文件的例子，建立一個 _YellowBirdState() 

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

2. initState() : 當 State 被創建時，會調用此方法進行初始化的操作，例如初始化狀態（state）、訂閱事件、啟動動畫等。 

3. build() : 當發生調用 initState、didChangeDependencies、didUpdateWidget 或調用 setState 更改狀態時(也就是重建widget時)，都會調用此方法來構建當前的 Widget Tree 

4. didChangeDependencies() : 此方法在 initState 之後以及 State 對象的依賴關係通過 InheritedWidget 更改時立即調用 

5. didUpdateWidget() : 每當 widget configuration 更改時，都會調用此方法。 

6. deactivate() : 當 Widget 從樹中被移除時，會調用此方法，通常在這個方法中可以做一些清理工作，比如取消訂閱事件等。 

7. dispose() : 當 Widget 從 Widget tree 中永久刪除時，會調用此方法。並且釋放該 Widget 保留的所有資源


以下是一個 Timer 範例，在 initState() 中創建了一個 Timer，每秒更新一次 _seconds 變數，並在 dispose() 中取消該 Timer。這樣做可以確保當該 widget 被移除時，計時器也會被正確地停止。
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

## Bloc
Bloc 是一個 Flutter 的狀態管理套件，全名為 Business Logic Component。它的目的是幫助 Flutter 開發者簡化應用程式中的業務邏輯和狀態管理，使得應用程式的程式碼更加簡潔，可讀性更高。

Bloc 主要由三個元素組成：
1. 事件 (Event)：使用者的操作、網路請求等等都是事件，它們觸發狀態的改變。 
2. 狀態 (State)：狀態是應用程式的當前狀態，它會隨著事件的發生而改變。 
3. 邏輯 (Logic)：Bloc 中包含所有的業務邏輯，例如從網路請求中獲取數據，並將數據映射到狀態中。

Bloc 套件的核心是 Bloc 類別，這個類別包含一個 Stream 以及一個 Event Handler。當有事件進入事件處理器時，Bloc 會根據當前狀態以及事件的類型來決定下一個狀態。狀態的改變會被流輸出，可以通過監聽這個 Stream 來更新 UI。

Bloc 套件的另一個重要概念是 Cubit，它是一個輕量級的 Bloc。Cubit 可以看作是 Bloc 的簡化版，它只包含狀態以及一些業務邏輯，沒有事件處理器。以下是兩者的優點分析：
### Cubit Advantages
使用 Cubit 的優點是簡單，只需要定義狀態以及我們想要公開的函數來改變狀態。相較之下，使用 Bloc 需要定義狀態、事件以及事件處理程式的實現。因此，使用 Cubit 比較容易理解，程式碼量也比較少。
### Bloc Advantages
使用 Bloc 的優點是追蹤性，因為當狀態對於應用程式的功能非常重要時，使用更多的事件驅動方法可以捕獲所有事件以及狀態變化。對於一些關鍵的應用程式狀態，追蹤其狀態變化的流程會非常有幫助。

此外，Bloc還可以使用許多反應式操作，例如緩衝、節流等。Bloc提供的事件接收器允許我們控制和轉換事件的流，例如實現一個即時搜尋功能時，我們可以使用自定義的 EventTransformer 來處理事件，讓後端的請求可以適當的節流，減少負擔。

# Bloc_Event


