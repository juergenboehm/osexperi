#ifndef __fs_fcntl_h
#define __fs_fcntl_h


#define O_ACCMODE	00000003
#define O_RDONLY	00000000
#define O_WRONLY	00000001
#define O_RDWR		00000002

#define O_CREAT		00000100	/* not fcntl */

#define O_EXCL		00000200	/* not fcntl */

#define O_NOCTTY	00000400	/* not fcntl */

#define O_TRUNC		00001000	/* not fcntl */

#define O_APPEND	00002000

#define O_NONBLOCK	00004000

#define O_SYNC		00010000

#define FASYNC		00020000	/* fcntl, for BSD compatibility */

#define O_DIRECT	00040000	/* direct disk access hint */

#define O_LARGEFILE	00100000

#define O_DIRECTORY	00200000	/* must be a directory */

#define O_NOFOLLOW	00400000	/* don't follow links */

#define O_NOATIME	01000000

#define O_CLOEXEC	02000000	/* set close_on_exec */

#define O_NDELAY	O_NONBLOCK



#endif
