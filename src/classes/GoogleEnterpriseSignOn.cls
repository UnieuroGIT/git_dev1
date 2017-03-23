global class GoogleEnterpriseSignOn implements Auth.RegistrationHandler{

global boolean canCreateUser(Auth.UserData data) {
  if(data.email!=null) // this null checking is just for demo purpose
  {
      return true;
  }
  else
  {
      return false;
  }
}

global User createUser(Id portalId, Auth.UserData data){

    if(canCreateUser(data))
    {
        List<User> users = [select Id from User where Google_ID__c=:data.identifier];
        if(users.size()==1)
        {
            system.debug('#1##'+users[0]);
            return users[0];
        }
        else
        {
            User u = new User();
            Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
            u.username = data.email.substring(0,data.email.indexOf('@'))+ '@sampleCompany.com';
            u.email = data.email;
            u.lastName = data.lastName;
            u.firstName = data.firstName;
            String alias = data.firstName.substring(0,1)+data.lastName.substring(0,4);
            if(alias.length() > 8) {
                alias = alias.substring(0, 8);
            }
            u.alias = alias;
            u.languagelocalekey = 'en_US';
            u.localesidkey = 'en_US';
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = 'America/Los_Angeles';
            u.profileId = p.Id;
            u.Google_ID__c = data.identifier;
            insert u;
            return u;
        }
    }
    else
    {
        return null;
    }
}

global void updateUser(Id userId, Id portalId, Auth.UserData data){
    User u = new User(Id=userId);
    u.Google_ID__c = data.identifier;
    update u;
}
}