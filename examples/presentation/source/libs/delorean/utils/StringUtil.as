package delorean.utils {
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	/**
	 * Helper for Strings.
	 */
	public class StringUtil {
		
		public static function toHtmlHex(hex:uint):String {
			var str:String
			
			str = hex.toString(16);
			while (str.length < 6) {
				str = "0" + str;
			}
			
			return ("#" + str);
		}
		
		
		public static function toHex(htmlColor:String):uint {
			if (htmlColor.indexOf("#") == 0) {
				htmlColor = htmlColor.substr(1);
			}
			
			htmlColor = "0x" + htmlColor;
			
			return uint(htmlColor);
		}
		
		
		public static function addZeros(originalData:*, length:uint):String {
			var str:String;
			
			str = originalData.toString();
			
			while (str.length < length) {
				str = "0" + str;
			}
			
			return str;
		}
		
		
		public static function caseInsensitivyCompare(stringA:String, stringB:String):Boolean {
			
			stringA = (stringA) ? stringA.toLowerCase() : "";
			stringB = (stringB) ? stringB.toLowerCase() : "";
			
			return (stringA.toLowerCase() == stringB.toLowerCase());
		}
		
		
		public static function removeAccentuation(string:String):String {
			var accents:Array;
			var i:uint;
			var pattern:RegExp;
			
			accents = [
				{ from: /[àáâãä]/img,	to:"a" },
				{ from: /[èéêë]/img,	to:"e" },
				{ from: /[ìíîî]/img,	to:"i" },
				{ from: /[òóôõö]/img,	to:"o" },
				{ from: /[ùúûü]/img,	to:"u" },
				{ from: /[ç]/img,		to:"c" },
				{ from: /[ñ]/img,		to:"n" },
			];
			
			for (i = 0; i < accents.length; i++) {
				pattern = accents[i].from;
				string = string.replace(pattern, accents[i].to);
				
				pattern = new RegExp(pattern.source.toUpperCase(), "img");
				string = string.replace(pattern, accents[i].to.toUpperCase());
			}
			
			return string;
		}
		
		public static function removePonctuation(string:String):String {

			var pattern:RegExp;

			pattern = /[-:,.]/img;
			string = string.replace(pattern, '');
			
			pattern = new RegExp(pattern.source, "img");
			string = string.replace(pattern, '');
			
			return string;
		}
		
		
		public static function soundsLike(patternString:String, searchString:String):int {
			var pattern:RegExp;
			
			patternString = removeAccentuation(patternString).toLowerCase();
			searchString = removeAccentuation(searchString).toLowerCase();
			
			var fixed:String = (patternString.split("").join("(.*)"));
			pattern = new RegExp(fixed, "ximg");
			
			return searchString.search(pattern);
			
		}
		
		
		public static function replaceHrefs(string:String):String {
			var pattern:RegExp;
			
			pattern = /(<a)(.*?)(href=)(['"])/img;
			
			return string.replace(pattern, "$1$2href=$4event:");
		}
		
		
		
		public static function removeWhiteSpace(string:String) : String {
			var whitespace:RegExp = /(\t|\n|\s)/g;
			
			return string.replace(whitespace, "");
		}
		
		
		public static function compareStrings(string1 : String, string2 : String) : Boolean {
			return (removeAccentuation(removePonctuation(removeWhiteSpace(string1.toLowerCase()))) == removeAccentuation(removePonctuation(removeWhiteSpace(string2.toLowerCase()))))
		}
		
		
		public static function clearAll(str : String) : String {
			return removeAccentuation(removeWhiteSpace(str.toLowerCase()))
		}
		
		
		public static function getYoutubeId(str : String) : String {
			var regExpVideoId : RegExp = /(?<=v(\=|\/))([-a-zA-Z0-9_]+)|(?<=youtu\.be\/)([-a-zA-Z0-9_]+)/gim;
			return regExpVideoId.exec(str)[0];
		}
		
		public static function checkValidURL(url:String) :Boolean {
			var regex:RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
			return (regex.test(url)); // returns true if valid url is found
		}
		
	}
	
}