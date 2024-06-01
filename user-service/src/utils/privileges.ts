import { Privileges } from '../types';

const UserPrivileges: Privileges = {

};

export function getPrivileges(value: string[]): Privileges {
  const privileges: Privileges = {};

  if (value instanceof Array) {
    value.forEach(i => {
      if (typeof i === 'string' && UserPrivileges[i])
        privileges[i] = true;
    });
  }

  return privileges;
}

export default UserPrivileges;
