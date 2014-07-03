package
{
	public dynamic class DomQuery
	{
		private var _dom:Object;
		public function get dom():Object{
			return _dom;
		}
		
		private var _win:Object;
		public function get window():Object{
			return _win;
		}
		public function set window(v:Object):void{
			_win = v;
			if(v)
				_dom = v['document'];
		}
		
		public var length:int=0;
		public function DomQuery(){
		}
		
		public static function New(win:Object):DomQuery{
			var d:DomQuery = new DomQuery();
			d.window = win;
			return d;
		}
		
		public function val(v:Object=null):String{
			if(v){
				switch(this[0].tagName){
					case 'INPUT':
						this[0].value = String(v);
						break;
					case 'TEXTAREA':
						this[0].value.innerHTML = String(v);
						break;
				}
				return String(v);
			}
			
			switch(this[0].tagName){
				case 'INPUT':
					return String(this[0].value);
				case 'TEXTAREA':
					return String(this[0].innerHTML);
			}
			return '';
		}
		
		public function parent():DomQuery{
			var i:int,k:int,isSame:Boolean,
				q:DomQuery = New(window),
				nodes:Array = this.allNodes();
			
			for(i=0;i<nodes.length;i++){
				isSame = false;
				for(k=0;k<q.length;k++){
					isSame = q[k].isSameNode(nodes[i].parentNode);
					if(isSame)
						break;
				}
				if(isSame)
					continue;
				
				q.addNode(nodes[i].parentNode)
			}

			return q;
		}
		
		public function next():DomQuery{
			var i:int,k:int,isSame:Boolean,
				q:DomQuery = New(window),
				nodes:Array = allNodes();
			
			for(i=0;i<nodes.length;i++){
				if(!nodes[i].nextElementSibling)
					continue;
				
				isSame = false;
				for(k=0;k<q.length;k++){
					isSame = q[k].isSameNode(nodes[i].nextElementSibling);
					if(isSame)
						break;
				}
				if(isSame)
					continue;
				
				q.addNode(nodes[i].nextElementSibling)
			}
			return q;
		}
		
		public function prev():DomQuery{
			var i:int,k:int,isSame:Boolean,
			q:DomQuery = New(window),
				nodes:Array = allNodes();
			
			for(i=0;i<nodes.length;i++){
				if(!nodes[i].previousElementSibling)
					continue;
				
				isSame = false;
				for(k=0;k<q.length;k++){
					isSame = q[k].isSameNode(nodes[i].previousElementSibling);
					if(isSame)
						break;
				}
				if(isSame)
					continue;
				
				q.addNode(nodes[i].previousElementSibling)
			}
			
			return q
		}
		
		public function each(func:Function):void{
			for(var i:int=0;i<length;i++){
				func.call(this[i])
			}
		}
		
		public function get(i:int):Object{
			return this[i];
		}
		
		public function data(name:String, val:Object=null):String{
			return attr('data-'+name, val);
		}
		
		public function attr(name:String, val:Object=null):String{
			if(length==0){
				return null;
			}
			
			if(val!=null){
				for(var i:int=0;i<this.length;i++){
					this[i].setAttribute(name, String(val));
				}
				
				return null
			}
			
			return String(this[0].getAttribute(name))
		}
		
		public function text(s:String = null):String{
			if(this.length==0){
				return '';
			}
			if(s==null){
				return this[0].innerText
			}else{
				for(var i:int=0;i<this.length;i++){
					this[i].innerText = s
				}
			}
			
			return s
		}
		
		public function html(s:String = null):String{
			if(this.length==0){
				return '';
			}
			if(s==null){
				return this[0].innerHTML
			}else{
				for(var i:int=0;i<this.length;i++){
					this[i].innerHTML = s
				}
			}
			
			return s
		}
		
		protected function addNode(n:Object):void{
			this[length] = n;
			this.length += 1;
		}
		
		protected function allNodes():Array{
			var i:int,
				nodes:Array = [];
			if(this.length==0){
				nodes.push(dom.body);
			}else{
				for(i=0;i<this.length;i++){
					nodes.push(this[i]);
				}
			}
			return nodes;
		}
		
		public function find(selector:String):DomQuery{
			var arr:Array = selector.split(' '),
				found:Array = this.allNodes(),
				i:int, k:int, 
				m:Object,
				s:String='',
				sData:Object;
			try{
				for(i=0;i<arr.length;i++){
					s = String(arr[i]);
					if(s.charAt()=='#'){
						m = /^#([\w\-]+)/g.exec(s);
						found = [dom.getElementById(m[1])];
					}else {
						sData = parseSelector(s);
						found = bySelector(found, sData.tag, sData.classNames, sData.attrs, sData.func)
					}
				}
			}catch(err){
				return DomQuery.New(window);
			}
			
			
			var q:DomQuery = DomQuery.New(this.window);
			for(i=0;i<found.length;i++){
				q.addNode(found[i]);
			}
			
			return q;
		}
		
		protected function parseSelector(s:String):Object{
			var m:Object = true,
				tag:String='*',
				classNames:Array = [],
				attrs:Array = [],
				func:Array = [],
				reg:RegExp;
			
			m = /^(\w+)/g.exec(s);
			if(m){
				tag = m[1];
			}
			
			reg = /\.([\w\-]+)/g;
			do{
				m = reg.exec(s);
				if(m){
					classNames.push(m[1]);
				}
			}while(m);
			
			reg = /\[(.+?)\]/g;
			do{
				m = reg.exec(s);
				if(m){
					attrs.push(m[1]);
				}
			}while(m);
			
			reg = /:(([\w\-]+)\(\d+\))/g;
			do{
				m = reg.exec(s);
				if(m && ['eq','first','last'].indexOf(m[2])>-1){
					func.push(m[1]);
				}
			}while(m);
						
			return {tag:tag, classNames:classNames, attrs:attrs, func:func};
		}
		
		protected function bySelector(nodes:Array, tag:String, classNames:Array, attrs:Array, func:Array):Array{
			if(tag==''){
				tag = '*';
			}
			
			var i:int,k:int,n:int,
				arr:Object,
				names:Array,
				className:String,
				found:Array = [],
				isFound:Boolean = true;
				
			for(i=0;i<nodes.length;i++){
				arr = nodes[i].getElementsByTagName(tag);
				for(k=0;k<arr.length;k++){
					isFound= true;
					
					for(n=0;n<classNames.length;n++){
						isFound = isFound && this.hasClassName(arr[k], classNames[n]);
					}
					for(n=0;n<attrs.length;n++){
						isFound = isFound && this.attrEqual(arr[k], attrs[n]);
					}
					if(!isFound)
						continue;
					
					found.push(arr[k]);
				}
				
			}
			
			for(n=0;n<func.length;n++){
				found = this.execFunc(found, func[n]);
			}
				
			return found;
		}
		
		protected function execFunc(found:Array, s:String):Array{
			if(found.length==0)
				return found;
			
			var reg:RegExp =/(.+)\((\d+)\)?/g,
				m:Object = reg.exec(s);
			
			if(!m || m.length<2){
				throw new Error('selector func '+s+' is failed.');
			}
			
			switch(m[1]){
				case 'eq':
					var n:int = parseInt(m[2]);
					if(found.length>n)
						return [found[n]]
					else
						return [];
				case 'first':
					return [found[0]];
				case 'last':
					return [found[found.length-1]];
			}
				
			return found;
		}
		protected function attrEqual(node:Object, s:String):Boolean{
			if(!node.hasAttribute)
				return false;
			
			var arr:Array = s.split('=');
			if(!node.hasAttribute(arr[0])){
				return false;
			}
			
			if(arr.length>1){
				return node.getAttribute(arr[0])==arr[1]
			}
			return true;
		}
		
		protected function hasClassName(node:Object, clas:String):Boolean{
			if(node.hasClassName){
				return node.hasClassName(clas)
			}
			
			var arr:Array = String(node.className).split(' ');
			return arr.indexOf(clas)>-1;
		}
		
		protected function getById(sid:String):DomQuery{
			var node:Object = dom.getElementById(sid),
				q:DomQuery = DomQuery.New(window);
			if(node){
				q.length = 1;
				return q[0] = node;
			}
			
			return q;
		}
	}
}