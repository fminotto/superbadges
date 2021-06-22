global class DailyLeadProcessor implements Schedulable {
    global void execute(SchedulableContext ctx) {
		List<Lead> leads = [SELECT Id, LeadSource  
                            FROM Lead
                            WHERE LeadSource = null LIMIT 200];

		if(!leads.isEmpty()) {
			for(Lead l: leads) {
				l.LeadSource = 'Dreamforce';
			}
			update leads;
		}
    }
}