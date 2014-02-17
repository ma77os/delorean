package delorean.net
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Tiago Canzian
	 */
	
	/**
	 * 	
	 	Example to call services
		
		- Wrapper multi from service:
	  	var serviceCalls : Array = [];
		serviceCalls.push({methodName: "GetMenu", Params: null}); 
		serviceCalls.push({methodName: "GetLastLogins", Params: null});
		services.addServices(serviceCalls, "GetData", serviceCalls, true);
		services.onComplete(this.onComplete); // Return an array of Services; 
		services.call();
		
		****************
		- Single call with independent callback:
		services.addService('login', 'Login', {cpf: '12345678911', password: '123'}).onComplete(this.onComplete); // Return Service
		services.call();
		
		**************** 
		- Single call with general callback:
		services.addService('login', 'GetMenu');
		services.onComplete(this.onComplete);
		services.call();
	 *
	 * */ 
	public class ServiceManager extends EventDispatcher {
		
		private static const MULTIPLE_SERVICE_ID : String = 'multiple'; 
		
		protected var registeredServices	: Dictionary;
		protected var servicesToLoad		: Array = [];
		protected var servicesLoaded		: Array = [];
		
		private var currentService			: int = 0;
		
		private var callbackComplete		: Function;
		
		private var serviceURL				: String;
		
		
		public function ServiceManager(serviceURL : String)
		{
			this.serviceURL = serviceURL;
			this.registeredServices = new Dictionary();
		}
		
		
		public function addServices(serviceIds : Array, serviceAction : String, serviceParams : Object = null, encode : Boolean = false, serviceMethod : String = 'POST') : Service
		{
			var service : Service = new Service(MULTIPLE_SERVICE_ID, this.serviceURL + serviceAction, serviceParams, serviceMethod);
			service.encode = encode;
			this.registeredServices[MULTIPLE_SERVICE_ID] = service;
			this.servicesToLoad.push(MULTIPLE_SERVICE_ID);
			
			return service;
		}
		
		
		public function addService(serviceId : String, serviceAction : String, serviceParams : Object = null, encode : Boolean = false, serviceMethod : String = 'POST') : Service
		{
			var service : Service = new Service(serviceId, this.serviceURL + serviceAction, serviceParams, serviceMethod);
			service.encode = encode;
			this.registeredServices[service.id] = service;
			this.servicesToLoad.push(service.id);
			
			return service;
		}
		
	
		public function getServiceByID(serviceId:String) : Service
		{
			return this.registeredServices[serviceId];
		}
		
		
		public function call() : void
		{
			var service : Service = this.getServiceByID(this.servicesToLoad[this.currentService]);
			
			var request : Request = new Request(service.url, service.params, service.encode);
			request.addEventListener(ServiceEvent.REQUEST_COMPLETE, _onComplete, false, 0, true);
			request.addEventListener(ServiceEvent.REQUEST_ERROR, _onError, false, 0, true);
		}
		
		public function onComplete(callback : Function) : ServiceManager
		{
			this.callbackComplete = callback;
			return this;
		}
		
		private function _onComplete(ev : ServiceEvent) : void
		{
			var service:Service = ev.target as Service;
			
			service.data = ev.json;
			service.rawContent = ev.rawContent;
			service.complete();
			
			if (currentService < servicesToLoad.length - 1)
			{
				currentService++;
				call();
				
			}
			else
			{
				complete();
			}
			
		}
		
		private function _onError(ev : ServiceEvent) : void
		{
			var service:Service = ev.target as Service;
			
			service.errorType = ev.param;
			service.error();
			
			if (currentService < servicesToLoad.length - 1)
			{
				currentService++;
				call();
				
			}
			else
			{
				complete();
			}
			
		}
		
		private function complete() : void
		{
			this.servicesToLoad = [];
			
			for each (var key:Service in this.registeredServices)
			{
				this.servicesLoaded.push(key);
			}
			
			if (this.callbackComplete != null) this.callbackComplete(this.servicesLoaded);
		}
	}
}