export type Roles = 'user' | 'admin'

export const isRoleExst = (userRole: Roles, requiredRole: Roles): boolean => {
  if (!userRole) {
    return false;
  }

  return userRole === requiredRole;
};

export const isAdmin = (userRole: Roles): boolean => {
  return isRoleExst(userRole, 'admin');
};

export const isUser = (userRole: Roles): boolean => {
  return isRoleExst(userRole, 'user');
};