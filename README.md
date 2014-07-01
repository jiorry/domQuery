domQuery
========

Jquery style selector engine for as3 (ActionScript3)

Example
========

```
var win:Object = htmlBrowser.domWindow;
var dom:Object = win['document'];
var q:DomQuery = DomQuery.New(dom);
var a:DomQuery = q.find('#result');
trace(a.attr('class'));

```