/*
 * $Id$
 *
 * Postgresql schema for FreeRADIUS
 *
 * All field lengths and types need checking as some are still either
 * suboptimal. -pnixon 2003-07-13
 *
 */

/*
 * Table structure for table 'radacct'
 *
 * Note: Column type BIGSERIAL does not exist prior to Postgres 7.2
 *       If you run an older version you need to change this to SERIAL
 */
CREATE TABLE radacct (
	RadAcctId		BIGSERIAL PRIMARY KEY,
	AcctSessionId		VARCHAR(32) DEFAULT '' NOT NULL,
	AcctUniqueId		VARCHAR(32) DEFAULT '' NOT NULL,
	UserName		VARCHAR(32) DEFAULT '' NOT NULL,
	Realm			VARCHAR(30) DEFAULT '',
	NASIPAddress		VARCHAR(15) DEFAULT '' NOT NULL,
	NASPortId		NUMERIC(12),
	NASPortType		VARCHAR(32),
	AcctStartTime		TIMESTAMP without time zone NOT NULL,
	AcctStopTime		TIMESTAMP without time zone,
	AcctSessionTime		NUMERIC(12),
	AcctAuthentic		VARCHAR(32),
	ConnectInfo_start	VARCHAR(32),
	ConnectInfo_stop	VARCHAR(32),
	AcctInputOctets		NUMERIC(12),
	AcctOutputOctets	NUMERIC(12),
	CalledStationId		VARCHAR(50) DEFAULT '' NOT NULL,
	CallingStationId	VARCHAR(50) DEFAULT '' NOT NULL,
	AcctTerminateCause	VARCHAR(32) DEFAULT '' NOT NULL,
	ServiceType		VARCHAR(32),
	FramedProtocol		VARCHAR(32),
	FramedIPAddress		INET,
	AcctStartDelay		NUMERIC(12),
	AcctStopDelay		NUMERIC(12)
);
CREATE UNIQUE INDEX radacct_combo on radacct (AcctStartTime, nasipaddress, AcctUniqueId);
/*
 * There was WAAAY too many indexes previously. This combo index
 * should take care of the most common searches.
 * I have commented out all the old indexes, but left them in case
 * someone wants them. I don't recomend anywone use them all at once
 * as they will slow down your DB too much.
 *  - pnixon 2003-07-13
 */

/*
 * create index radacct_UserName on radacct (UserName);
 * create index radacct_AcctSessionId on radacct (AcctSessionId);
 * create index radacct_AcctUniqueId on radacct (AcctUniqueId);
 * create index radacct_FramedIPAddress on radacct (FramedIPAddress);
 * create index radacct_NASIPAddress on radacct (NASIPAddress);
 * create index radacct_AcctStartTime on radacct (AcctStartTime);
 * create index radacct_AcctStopTime on radacct (AcctStopTime);
*/



/*
 * Table structure for table 'radcheck'
 */
CREATE TABLE radcheck (
	id		SERIAL PRIMARY KEY,
	UserName	VARCHAR(30) DEFAULT '' NOT NULL,
	Attribute	VARCHAR(30),
	op VARCHAR(2)	NOT NULL DEFAULT '==',
	Value		VARCHAR(40)
);
create index radcheck_UserName on radcheck (UserName,Attribute);

/*
 * Table structure for table 'radgroupcheck'
 */
CREATE TABLE radgroupcheck (
	id		SERIAL PRIMARY KEY,
	GroupName	VARCHAR(20) DEFAULT '' NOT NULL,
	Attribute	VARCHAR(40),
	op		VARCHAR(2) NOT NULL DEFAULT '==',
	Value		VARCHAR(40)
);
create index radgroupcheck_GroupName on radgroupcheck (GroupName,Attribute);

/*
 * Table structure for table 'radgroupreply'
 */
CREATE TABLE radgroupreply (
	id		SERIAL PRIMARY KEY,
	GroupName	VARCHAR(20) DEFAULT '' NOT NULL,
	Attribute	VARCHAR(40),
	op		VARCHAR(2) NOT NULL DEFAULT '=',
	Value		VARCHAR(40)
);
create index radgroupreply_GroupName on radgroupreply (GroupName,Attribute);

/*
 * Table structure for table 'radreply'
 */
CREATE TABLE radreply (
	id		SERIAL PRIMARY KEY,
	UserName	VARCHAR(30) DEFAULT '' NOT NULL,
	Attribute	VARCHAR(30),
	op		VARCHAR(2) NOT NULL DEFAULT '=',
	Value		VARCHAR(40)
);
create index radreply_UserName on radreply (UserName,Attribute);

/*
 * Table structure for table 'usergroup'
 */
CREATE TABLE usergroup (
	id		SERIAL PRIMARY KEY,
	UserName	VARCHAR(30) DEFAULT '' NOT NULL,
	GroupName	VARCHAR(30)
);
create index usergroup_UserName on usergroup (UserName);

/*
 * Table structure for table 'realmgroup'
 */
CREATE TABLE realmgroup (
	id		SERIAL PRIMARY KEY,
	RealmName	VARCHAR(30) DEFAULT '' NOT NULL,
	GroupName	VARCHAR(30)
);
create index realmgroup_RealmName on realmgroup (RealmName);

/*
 * Table structure for table 'realms'
 * This is not yet used by FreeRADIUS 
 */
CREATE TABLE realms (
	id		SERIAL PRIMARY KEY,
	realmname	VARCHAR(64),
	nas		VARCHAR(128),
	authport	int4,
	options		VARCHAR(128) DEFAULT ''
);

/*
 * Table structure for table 'nas'
 * This is not currently used by FreeRADIUS but is usefull for reporting
 * anyway.
 */
CREATE TABLE nas (
	id		SERIAL PRIMARY KEY,
	nasname		VARCHAR(128),
	shortname	VARCHAR(32) NOT NULL,
	ipaddr		INET NOT NULL,
	type		VARCHAR(30),
	ports		int4,
	secret		VARCHAR(60) NOT NULL,
	community	VARCHAR(50),
	snmp		VARCHAR(10),
	naslocation	VARCHAR(32)
);

