import { ActivityLog } from '../models';

const activity = async (uid: number, ip: string, activity: string): Promise<void> => {
  await ActivityLog.create(
    {
      userId: uid,
      ip: ip,
      activity: activity
    }
  ).catch((err: Error) => err);
};

export default activity;
