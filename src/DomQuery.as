package
{
	public dynamic class DomQuery
	{
		public var dom:Object;
		public var length:int=0;
		public function DomQuery(){
		}
		
		public static function New(document:Object):DomQuery{
			var d:DomQuery = new DomQuery();
			d.dom = document;
			return d;
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
		
		protected function add(n:Object):void{
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
			
			for(i=0;i<arr.length;i++){
				s = String(arr[i]);
				if(s.charAt()=='#'){
					m = /^#([\w\-]+)/g.exec(s);
					found = [dom.getElementById(m[1])];
				}else {
					sData = parseSelector(s);
					found = bySelector(found, sData.tag, sData.classNames, sData.attrs)
				}
			}
			
			var q:DomQuery = DomQuery.New(this.dom);
			for(i=0;i<found.length;i++){
				q.add(found[i]);
			}
			
			return q;
		}
		
		protected function parseSelector(s:String):Object{
			var m:Object = true,
				tag:String='*',
				classNames:Array = [],
				attrs:Array = [],
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
						
			return {tag:tag, classNames:classNames, attrs:attrs};
		}
		
		protected function bySelector(nodes:Array, tag:String, classNames:Array, attrs:Array):Array{
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
				
			return found;
		}
		
		private function attrEqual(node:Object, s:String):Boolean{
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
		
		private function hasClassName(node:Object, clas:String):Boolean{
			if(node.hasClassName){
				return node.hasClassName(clas)
			}
			
			var arr:Array = String(node.className).split(' ');
			return arr.indexOf(clas)>-1;
		}
		
		public function getById(sid:String):DomQuery{
			var node:Object = dom.getElementById(sid),
				q:DomQuery = DomQuery.New(dom);
			if(node){
				q.length = 1;
				return q[0] = node;
			}
			
			return q;
		}
	}
}