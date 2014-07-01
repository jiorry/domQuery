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
		
		public function find(selector:String):DomQuery{
			var arr:Array = selector.split(' '),
				found:Array = [],
				i:int, k:int, 
				s:String='',
				arr2:Array,
				clsNames:Vector.<String>;
			
			for(i=0;i<arr.length;i++){
				s = String(arr[i]);
				if(s.charAt()=='#'){
					found = [dom.getElementById(s.substr(1))];
				}else {
					arr2 = s.split('.');
					clsNames = new Vector.<String>();
					for(k=0;k<arr2.length;k++){
						clsNames.push(String(arr2[k]));
					}
					found = byClassNames(arr2[0], clsNames)
				}
			}
			
			var q:DomQuery = DomQuery.New(this.dom);
			for(i=0;i<found.length;i++){
				q.add(found[i]);
			}
			
			return q;
		}
		
		protected function add(n:Object):void{
			this[length] = n;
			this.length += 1;
		}
		
		protected function allNodes():Array{
			var i:int,
				nodes:Array = [];
			if(this.length==0){
				for(i=0;i<dom.all.length;i++){
					nodes.push(dom.all[i]);
				}
			}else{
				for(i=0;i<this.length;i++){
					nodes.push(this[i]);
				}
			}
			return nodes;
		}
		
		private function byClassNames(tag:String, classNames:Vector.<String>):Array{
			if(tag==''){
				tag = '*';
			}
			
			var nodes:Array = allNodes(),
				i:int,k:int,n:int,
				arr:Object,
				names:Array,
				found:Array = [],
				isFound:Boolean = true;
				
			for(i=0;i<nodes.length;i++){
				arr = nodes[i].getElementsByTagName(tag);
				for(k=0;k<arr.length;k++){
					names = String(arr[k].classNames).split(' ');
					isFound= true;
					for(n=0;n<names.length;n++){
						isFound = isFound && arr[k].hasClassName(names[n]);
					}
					if(!isFound)
						continue;
					
					found.push(arr[k]);
				}
			}
				
			return found;
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