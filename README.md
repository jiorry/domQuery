domQuery
========

Jquery style selector engine for as3 (ActionScript3)

Example
========

```
DomQuery.SetBrowser(htmlBrowser);

var q:DomQuery = DomQuery.$('#result');
trace(a.attr('class'));

q.find('a').each(function():void{
	trace(DomQuery.$(this).attr('href'));
	trace(this.getAttribute('href'));
})

q.parent().next().prev().find('span[data-action=xxx]')

q.find('div.item:eq(2)').html()

```