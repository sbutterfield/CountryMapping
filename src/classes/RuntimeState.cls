/**
 *  @author: Shawn Butterfield, Salesforce.com, Inc
 *  This class is used as a process controller for individual contexts of trigger and/or class related runtimes
 *  The static variables assigned here can be set and shared acrossed a single running contexts or thrown into a future one
 */
 
global virtual class RuntimeState {

	global static Boolean isInFutureContext = false;
	
	global static Boolean origContextWasInsert = false;
	
	global static Boolean origContextWasUpdate = false;
	
	global static Boolean continuumHasBeenSet = false;
	
	global static Set<Id> setContinuum;
	
	/**
	 *	@method: getRunStatus
	 *	@param: Set<> of Ids
	 *	The method is passed a set of record Ids and is compared to another continuum set of record Ids within the current running context.
	 *	If the set has already been through the current context, the method returns true. If not, the method add's the new Ids to the continuum and returns false.
	 */
	
	global static Boolean getRunStatus(Set<Id> idSet) {
		
		if(!continuumHasBeenSet) { setContinuum = new Set<Id>(); }
		
		if(!setContinuum.containsAll(idSet)) {
			
			for(Id thisId : idSet) {
			
				setContinuum.add(thisId);
			}
			
			continuumHasBeenSet = true;
			return false;
		}
		else {
			
			return true;
		}
	}
}