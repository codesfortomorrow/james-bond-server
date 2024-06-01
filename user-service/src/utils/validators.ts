import { User } from '../models';

export const isLockedUser = async (uid: number): Promise<boolean> => {
  const user = await User.findOne({ where: { id: uid } }).catch((err: Error) => err);

  if (user instanceof Error) return true;
  if (!user) return true;
  if (user.lock) return true;

  return false;
};

export const isUserBetLocked = async (uid: number): Promise<boolean> => {
  const user = await User.findOne({ where: { id: uid } }).catch((err: Error) => err);

  if (user instanceof Error) return true;
  if (!user) return true;
  if (user.betLock) return true;

  return false;
};
