/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Nuray Tisha
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> getAllLeads() {
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead];
    }


	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
		public static List<Contact> getContactsByFirstName(String firstName) {
			return [SELECT Id, FirstName, LastName, Name FROM Contact WHERE FirstName = :firstName];
	}


	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> getContactIdsByLastName (List<Contact> contacts) {
	List<Contact> contactsList = [SELECT Id FROM Contact WHERE LastName IN ('Smith', 'Jones')];

	// Extract the Ids into a list
	List<Id> contactIds = new List<Id>();
	for (Contact con : contactsList) {
		contactIds.add(con.Id);
	}

	return contactIds;
	}


	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> getClosedWonOppsByAccount (Id accountId) {
	return [SELECT Id, Name, StageName, Amount, CloseDate, AccountId, Account.Name 
			FROM Opportunity 
			WHERE StageName = 'Closed Won' AND AccountId = :accountId];
	}


	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer getAccountTotalCount () {
	return [SELECT COUNT() FROM Account];
	}


	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static  Map<Id, Task> getTaskRecords () {
	return new Map<Id, Task>([SELECT Id, ActivityDate, OwnerId, Subject, Status 
							FROM Task 
							WHERE ActivityDate = NEXT_N_DAYS:7]);
	}


	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> getContactsWithDomain () {
	return [SELECT Id, Name, Email, AccountId, Account.Name 
			FROM Contact
			WHERE Email LIKE '%@example.com'];
	}


	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		return [SELECT Id, Name, StageName, CloseDate, Amount
				FROM Opportunity
				WHERE Name LIKE :('%' + keyword + '%')]; // Filter opportunities by keyword in their Name
	}


	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		return [SELECT Id, Subject, Origin
				FROM Case
				WHERE Origin NOT IN ('Web', 'Email')
				AND Origin != null]; // Replace null with the variable you used to store the result
	}


	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getAllLeadsBySourceOrKeyword (String leadSource, String keyword) {
	return [SELECT Id, LastName, Company, Phone, Email, LeadSource, Title
			FROM Lead
			WHERE LeadSource = :leadSource OR Title LIKE :('%' + keyword + '%')];
	}


	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
    	// Query Contacts associated with the given AccountId and create a list to store LastNames
		List<Contact> contacts = [SELECT LastName
								FROM Contact
								WHERE AccountId = :accountId
								LIMIT 100];

    	// Extract LastNames into a list
    	List<String> contactLastNames = new List<String>();
    	for (Contact con : contacts) {
        contactLastNames.add(con.LastName);
    	}

    return contactLastNames; // Replace null with the variable you used to store the result
	} 


	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		// Use Aggregate Query to get the total revenue
		AggregateResult[] revenueByStage = [SELECT SUM(Amount) totalRevenue
											FROM Opportunity
											WHERE StageName = :stage OR Amount > 10000
											];

		Decimal totalRevenue = (Decimal)revenueByStage[0].get('totalRevenue');

		// Return the total revenue
		return totalRevenue; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		List<Account> firstTenAccts = [SELECT Id, Name
										FROM Account
										ORDER BY Name ASC
										LIMIT 10];
		return firstTenAccts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		List<Opportunity> highValueOpps = [SELECT Id, Name, CloseDate, Amount
										FROM Opportunity
										WHERE Amount > 100000
										ORDER BY CloseDate ASC
										LIMIT 5];
		return highValueOpps; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		List<Contact> recentBirthdateContacts = [SELECT Id, Name, Birthdate
											FROM Contact
											ORDER BY Birthdate DESC
											LIMIT 3];
		return recentBirthdateContacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		List<Case> openCases = [SELECT Id, CreatedDate, Status
								FROM Case
								WHERE Status != 'Closed'
								ORDER BY CreatedDate ASC
								LIMIT 10
								OFFSET 5];
		return openCases; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids
		Set<Id> caseIds = new Set<Id>();
		
		// Query the Cases
		List<Case> caseWithAccIds = [SELECT Id, Subject, Status, AccountId
									FROM Case
									WHERE AccountId = :accountId];

		// Loop through each Case and add the Id to the set
		for (Case cas: caseWithAccIds) {
			// Add the Case Id to the set
			caseIds.add(cas.Id);
		}

		return caseIds; // Return the set of Case Ids
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Names
		Map<Id, String> accountIdsToNames = new Map<Id, String>();

		// Query the Accounts
		List<Account> accounts = [SELECT Id, Name, BillingCountry
								FROM Account
								WHERE BillingCountry != :country
								ORDER BY Name ASC
								];
		
		// Loop through each Account and add the Id and Name to the map
		for (Account acc: accounts) {
			// Add the Account Id and Name to the map
			accountIdsToNames.put(acc.Id, acc.Name);
		}

		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		// Query the Contact
		Contact contact = [SELECT AccountId
							FROM Contact
							WHERE Id = :contactId];
		
		// Add the Account Name to the string
		String accountName = [SELECT Name
								FROM Account
								WHERE Id = :contact.AccountId].Name;
		return accountName; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		// Query the Account and related Opportunities
		Account account = [SELECT Id, Name,
								(SELECT Id, Name, StageName
								FROM Opportunities
								)
							FROM Account
							WHERE Id = :accountId];
		return account; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account
		Account account = [SELECT Id, Name, BillingState
							FROM Account
							WHERE Id = :accountId];

		// Store the Account's BillingState
		String accountBillingState = account.BillingState;

		// Query the Contacts
		List<Contact> contacts = [SELECT Id, Name, MailingState
									FROM Contact
									WHERE MailingState = :accountBillingState];
	
		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from the leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads
		List<Lead> leads = [SELECT Id, Email
							FROM Lead
							WHERE Id IN :leadIds];

		// Create a set of email domains from the Leads
		Set<String> emailDomains = new Set<String>();

		// Loop through each Lead to get the email
			for (Lead lead : leads) {
			if (lead.Email != null && lead.Email.contains('@')) {
				emailDomains.add(lead.Email.split('@')[1]);
			}
		}

		// Query the Accounts
		List<Account> accounts = [SELECT Id, Name, Website
								FROM Account
								WHERE Website != null];

		List<Account> matchingAccounts = new List<Account>();
		for (Account acc : accounts) {
			if (acc.Website != null) {
				String domain = acc.Website.toLowerCase().replace('www.', '');
				if (emailDomains.contains(domain)) {
					matchingAccounts.add(acc);
				}
			}
		}
	
		return matchingAccounts; // Replace null with the variable you used to store the result
		
	}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		// Query the original Opportunity Line Items
		List<OpportunityLineItem> lineItems = [SELECT Id, OpportunityId, Quantity, UnitPrice, PricebookEntryId
											FROM OpportunityLineItem
											WHERE OpportunityId = :origOppId];

		// Create a list to hold the new line items
		List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();

		// Generate a random number between 1 and 3
		Integer randomQuantity = (Integer) Math.floor(Math.random() * 3) + 1;

		// Loop through each cloned Opportunity Id
			for (Id cloneOppId : cloneOppIds) {
			// Clone the OpportunityLineItems
				for (OpportunityLineItem lineItem : lineItems) {
				newLineItems.add(new OpportunityLineItem(
					OpportunityId = cloneOppId,
					Quantity = lineItem.Quantity * randomQuantity,
					UnitPrice = lineItem.UnitPrice,
					PricebookEntryId = lineItem.PricebookEntryId
				));
				}
			}

		// Insert the new line items into the database
		if (!newLineItems.isEmpty()) {
			insert newLineItems;
		}
		
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		List<Opportunity> closeWonOpps = [SELECT Name, Account.Name, Owner.Name
										FROM Opportunity
										WHERE StageName = 'Closed Won'];
		return closeWonOpps; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */

	public static void setPrimaryContact() {
		// Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		List<Opportunity> oppList = getOpportunityDetailsForClosedWon();
	
		// Create a set of Account Ids from the Opportunities
		Set<Id> accountIds = new Set<Id>();
		for (Opportunity opp : oppList) {
			if (opp.AccountId != null) {
				accountIds.add(opp.AccountId);
			}
		}
	
		// Query the Contacts
		List<Contact> contacts = [SELECT Id, AccountId, FirstName
								  FROM Contact
								  WHERE AccountId IN :accountIds
								  ORDER BY FirstName ASC];
	
		// Map of AccountId, then add the first contact for each Account
		Map<Id, Contact> accountsToContactMap = new Map<Id, Contact>();
		for (Contact con : contacts) {
			if (!accountsToContactMap.containsKey(con.AccountId)) {
				accountsToContactMap.put(con.AccountId, con);
			}
		}
	
		// Set the Primary_Contact__c for each Opportunity
		for (Opportunity opp : oppList) {
			if (accountsToContactMap.containsKey(opp.AccountId)) {
				opp.Primary_Contact__c = accountsToContactMap.get(opp.AccountId).Id;
			}
		}
	
		// Update Opportunities
		if (!oppList.isEmpty()) {
			update oppList;
		}
	}
}
