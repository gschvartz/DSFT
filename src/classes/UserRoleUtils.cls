public class UserRoleUtils {
    private List<UserRole> childRoles = new List<UserRole>();

    public List<UserRole> getChildRoles(UserRole role) {
        populateChildRoles(new List<UserRole>{role});
        return childRoles;
    }

    private void populateChildRoles(List<UserRole> roles) {
        List<UserRole> childs = [
            SELECT Id, Name, ParentRoleId
            FROM UserRole
            WHERE ParentRoleId IN :roles
        ];
        
        childRoles.addAll(childs);
        if (childs.size() > 0) {
            populateChildRoles(childs);
        }
    }
}