package delorean.collections 
{
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class TreeNode 
	{
		public var key:*;
		public var data:*;
		public var parent:TreeNode;
		private var _root:TreeNode;
		
		private var _children:Vector.<TreeNode>;
		private var _path:Array;
		private var _pathString:String;
		
		public function TreeNode(key:* = null, data:* = null) 
		{
			this.key = key;
			this.data = data;
			_path = new Array (this);
			_pathString = "/" + key;
			
			_children = new Vector.<TreeNode>();
		}
		
		public function add (key:*, data:* = null):TreeNode
		{
			return addChild (new TreeNode (key, data));
		}
		
		public function addChild (node:TreeNode):TreeNode
		{
			for (var i:int; i < children.length; i++ )
			{
				if (node.key == children[i].key)
				{
					trace ("[TreeNode @add - ERROR: cannot add \""+node.key+"\" at \""+this.key+"\", there is already a sibling node with the same key]");
					node = null;
					return null;
				}
			}
			
			node._path = _path.concat(node._path);
			node._pathString = _pathString + node._pathString;
			node.parent = this;
			_children.push (node);
			return node;
		}
		
		public function remove (key:*):TreeNode
		{
			//log (this, "remove: " + key);
			var node:TreeNode = fetch (key);
			//log (this, "\thas node: " + node);
			if (node == null)
			{
				trace ("[TreeNode @remove - ERROR: cannot remove \""+key+"\", this node doesn't exists]");
				return null;
			}
			
			var index:int = node.parent.children.indexOf (node);
			if (index > -1) node.parent.children.splice (index, 1);
			//log (this, "\tindex of node: " +index);
			return node;
		}
		
		public function fecthFromPath (...keys):TreeNode
		{
			var node:TreeNode = root;
			
			var levels:int = keys.length;
			
			for (var i:int=0; i < levels; i++)
			{
				if (!node || !node.hasChildren ()) return null;
				
				var key:* = keys[i];
				var nFound:TreeNode = null;
				for (var j:int=0; j < node.children.length; j++ )
				{
					var n:TreeNode = node.children[j];
					
					if (n.key == key) 
					{
						nFound = n;
						break;
					}
				}
				
				node = nFound;
			}
			
			return node;
		}
		
		public function fetch (key:*):TreeNode
		{
			if (this.key == key) return this;
			
			if (hasChildren())
			{
				for (var i:int; i < children.length; i++ )
				{
					var node:TreeNode = children[i];
					if (node != null)
					{
						node = node.fetch (key);
						if (node != null) return node;
					}
				}
			}
			
			return null;
		}
		
		public function fromXML(xml:*):void 
		{
			if (xml.@key.length() > 0) key = xml.@key;
			if (xml.@data.length() > 0) data = xml.@data;
			
			if (xml.hasComplexContent())
			{
				_children = new Vector.<TreeNode>();
				for each (var n:* in xml.children())
				{
					if (n.@enabled == "false") continue;
					var node:TreeNode = new TreeNode ();
					node.parent = this;
					node.fromXML (n);
					_children.push (node);
				}
			}
		}
		
		public function getCommonAncestor (node1:TreeNode, node2:TreeNode):TreeNode
		{
			if (!node1.parent || !node2.parent) return root;
			
			var node:TreeNode = null;
			var path1:Array = node1.parent.path;
			var path2:Array = node2.parent.path;
			
			for (var i:int = path1.length -1; i >= 0; i--)
			{
				if (node) break;
				var n1:TreeNode = path1[i];
				for (var j:int = path2.length -1; j >= 0; j--)
				{
					var n2:TreeNode = path2[j];
					if (n2 == n1) {
						node = n1;
						break;
					}
				}
			}
			
			return node;
		}
		
		public function hasChildren():Boolean
		{
			return _children && _children.length > 0;
		}
		
		public function hasSiblings ():Boolean
		{
			return parent && parent.children && parent.children.length > 1;
		}
		
		public function clone ():TreeNode
		{
			var node:TreeNode = new TreeNode (key, data);
			if (hasChildren())
			{
				for (var i:uint; i < children.length; i++)
				{
					node.addChild(children[i].clone());
				}
			}
			return node;
		}
		
		public function get root():TreeNode
		{
			if (_root) return _root;
			
			var node:TreeNode = this;
			while (node.parent)
			{
				node = node.parent;
			}
			
			_root = node;
			
			return _root;
		}
		
		public function get path ():Array
		{
			return _path;
		}
		
		public function get children():Vector.<TreeNode> { return _children; }
		
		public function get pathString():String 
		{
			return _pathString;
		}
		
		public function get level ():int
		{
			var l:int = 0;
			
			var node:TreeNode = this;
			while (node.parent)
			{
				l++;
				node = node.parent;
			}
			
			return l;
		}
		
		public function toTreeString(tab:String = ""):String
		{
			var tabThis:String = tab;
			var str:String = tabThis + "[" + key + "]";
			
			if (_children.length > 0)
			{
				tab += "\t";
				for (var i:int; i < _children.length; i++)
				{
					var n:TreeNode = _children[i];
					str += "\n" + n.toTreeString(tab);
				}
				
				str += "\n"+tabThis;
			}
			
			str += "[/" + key + "]";
			return str;
		}
		
		public function toString():String 
		{
			return "[TreeNode key="+key+"]"
			//return "[TreeNode key=" + key  + " data=" + data + " parent=" + (parent ? parent.key : null) + " root=" + root.key + " children=" + children.length + 
						//"]";
		}
	}

}