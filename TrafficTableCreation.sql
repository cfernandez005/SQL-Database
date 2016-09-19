--Chris Fernandez
--5/6/16
--Assignment#3 More on Constraints
--Website used: traffic.511.org
--Database creation and insertion


--Current Incidents, Construction, & Events table creation
create table ICE
( typeTraffic varchar(15) not null,
  route varchar(20) not null,
  startTime timestamp not null,
  updated timestamp not null,
  description varchar(220) primary key);

--Events table creation
create table Events
( eventTime timestamp not null,
  description varchar(100) primary key);
  
--Construction Info table creation
create table ConstructionInfo
( infoTime timestamp primary key,
  description varchar(200),
  currentConstruction varchar (220),
  foreign key (currentConstruction) references ICE
  on delete no action on update cascade);
  --I chose no action on delete so that a deletion of the foreign keyed parent entry from ICE wouldn't also delete 
  --ConstructionInfo table's entry and cascade on update so that any updates to the ICE table will cascade to its
  --associated entrys in the ConstructionInfo table

--Caltrans Message Signs table creation
create table Caltrans
( lastUpdated timestamp not null,
  signLocation varchar(60) primary key,
  message varchar(60) not null);

 --News table creation
create table News
( newsTime timestamp primary key,
  description varchar(100),
  constructionInfoTime timestamp,
  foreign key (constructionInfoTime) references ConstructionInfo
  on delete cascade on update cascade);
  --I chose the cascade option on delete so that the News entry would be deleted if its foreign keyed parent from
  --ConstructionInfo is deleted and casade on update so that any updates to the ConstructionInfo parent will apply
  --to the child News entry as well


--constraints
alter table News
  add constraint uniqueNewsDes unique (description);

alter table ConstructionInfo
  add constraint uniqueConstructionInfoDes unique (description);

--functions
create or replace function dateComparison (a timestamp, b timestamp )
  returns timestamp as $func$
  begin
    if a < b
      then return a;
    else
      return b;
    end if;
  end;
  $func$ language plpgsql;

--functions
 create or replace function dateIsCurrent (x timestamp)
  returns boolean as $func$
  begin
    if x < current_date + 1
      then return true;
    else
      return false;
    end if;
  end;
  $func$ language plpgsql;



--IncidentsConstructionAndEvents data inserts
insert into ICE values ('incident', 'US-101 S', '2016-05-06 5:17 PM', '2016-05-06 5:18 PM',
  'CHP : Accident on US-101 Southbound north of Old Middlefield Way (Mountain View). Right shoulder blocked. Expect delays.');
insert into ICE values ('severe-incident', 'I-80 W', '2016-05-06 5:03 PM', '2016-05-06 5:16 PM',
  'CHP : Accident with injuries & Overturned vehicle & Severe traffic alert on I-80 Westbound at Gilman St (Berkeley). Left and
   center lanes blocked. Avoid the area.');
insert into ICE values ('incident', 'San Tomas Expy', '2016-05-06 5:13 PM', '2016-05-06 5:13 PM',
  'CHP : Accident on San Tomas Expy Northbound south of Saratoga Ave (Santa Clara). Right shoulder blocked. Expect delays.');
insert into ICE values ('incident', 'I-680 S', '2016-05-06 5:02 PM', '2016-05-06 5:11 PM',
  'CHP : Disabled vehicle on I-680 Southbound north of Berryessa Rd (San Jose). 2nd lane from the left blocked. Expect delays.');
insert into ICE values ('incident', 'I-880 S', '2016-05-06 5:10 PM', '2016-05-06 5:10 PM',
  'CHP : Disabled vehicle on I-880 Southbound south of Great Mall Pky (Milpitas). Left lane blocked. Expect delays.');
insert into ICE values ('incident', 'I-280 N', '2016-05-06 4:57 PM', '2016-05-06 5:09 PM',
  'CHP : Accident on I-280 Northbound north of I-380 W (San Bruno). Right lane blocked. Expect delays.');
insert into ICE values ('severe-incident', 'CA-29 S', '2016-05-06 4:54 PM', '2016-05-06 5:09 PM',
  'CHP : Accident on CA-29 Southbound at Oak Knoll Ave (Napa). Left lane and shoulder blocked. Expect delays.');
insert into ICE values ('incident', 'I-580 E', '2016-05-06 4:50 PM', '2016-05-06 5:08 PM',
  'CHP : Accident on I-580 Eastbound east of Airway Blvd (Livermore). Right shoulder blocked. Expect delays.');
insert into ICE values ('incident', 'I-880 N', '2016-05-06 4:49 PM', '2016-05-06 5:08 PM',
  'CHP : Accident on I-880 Northbound south of Mowry Ave (Fremont). Right shoulder blocked. Expect delays.');
insert into ICE values ('incident', 'I-880 S', '2016-05-06 4:11 PM', '2016-05-06 5:06 PM',
  'CHP : Accident on I-880 Southbound north of Davis St (San Leandro). 2nd lane from the left blocked. Expect delays.');
insert into ICE values ('incident', 'I-580 E', '2016-05-06 5:05 PM', '2016-05-06 5:05 PM',
  'CHP : Obstruction on I-580 Eastbound west of 163RD Ave (Castro Valley). 3rd lane from the left blocked. Expect delays.');
insert into ICE values ('incident', 'CA-17 N', '2016-05-06 5:02 PM', '2016-05-06 5:03 PM',
  'CHP : Accident on CA-17 Northbound south of Laurel Rd (Los Gatos). Right shoulder blocked. Expect delays.');
  
insert into ICE values ('construction', 'CA-1 N', '2016-05-05 7:05 PM', '2016-05-06 4:23 PM',
  'Caltrans : Long-term construction on CA-1 Northbound area of Panoramic Hwy (Unincorporated). Alternate lanes open. One way
   traffic control in effect.');
insert into ICE values ('construction', 'CA-12 E', '2016-04-18 7:15 PM', '2016-05-06 4:23 PM',
  'Caltrans : Long-term construction & Overnight roadwork on CA-12 Eastbound and Westbound between Ramal Rd (Unincorporated) and
   Napa Rd (Sonoma). Alternate lanes open. One way traffic control in effect.');
insert into ICE values ('construction', 'I-205 E', '2016-04-11 10:15 PM', '2016-05-06 4:23 PM',
  'Caltrans : Long-term construction on I-205 Eastbound between I-580 (Unincorporated) and I-5 (Tracy). Various lanes closed.
   Expect delays.');
insert into ICE values ('construction', 'Gravenstein Hwy', '2016-04-21 7:25 AM', '2016-05-06 4:22 PM',
  'Caltrans : Long-term construction on Gravenstein Hwy Eastbound and Westbound to CA-12 (Sebastopol). Right lane and shoulder
   closed. Expect delays.');
insert into ICE values ('construction', 'CA-152', '2016-04-19 6:40 PM', '2016-05-06 4:22 PM',
  'Caltrans : Long-term construction on CA-152 Eastbound and Westbound between Pole Line Rd (Gilroy) and Watsonville Rd (Gilroy).
   Alternate lanes open. One way traffic control in effect.');
insert into ICE values ('construction', 'CA-160 N', '2016-03-02 2:10 PM', '2016-05-06 4:22 PM',
  'Caltrans : Long-term construction on CA-160 Northbound and Southbound to CA-12 (Rio Vista). Alternate lanes open. One way 
   traffic control in effect.');
insert into ICE values ('construction', 'US-101 N', '2015-07-07 11:05 AM', '2016-05-06 4:22 PM',
  'Caltrans : Long-term construction on US-101 Northbound north of Embarcadero Rd (Palo Alto). Auxiliary Lane closed.
   Expect delays.');


--Events data insert
insert into Events values ('2016-05-06 4:05 PM', 'San Francisco Giants (MLB) Host Colorado at AT&T Park in San Francisco');
insert into Events values ('2016-05-06 4:04 PM', 'Rihanna Concert at SAP Center at San Jose');


--ConstructionInfo data inserts
insert into ConstructionInfo values ('2016-05-06 4:21 PM', 'CA-4 Widening Project Continues in East Contra Costa County');
insert into ConstructionInfo values ('2016-05-06 4:20 PM', 'I-680 Express Lane Project Between Walnut Creek and San Ramon');
insert into ConstructionInfo values ('2016-05-06 4:19 PM', 'I-205 Smart Corridor Improvement Project in San Joaquin County',
  'Caltrans : Long-term construction on I-205 Eastbound between I-580 (Unincorporated) and I-5 (Tracy). Various lanes closed.
   Expect delays.');
insert into ConstructionInfo values ('2016-05-06 4:18 PM', 'One-Way Traffic Controls on CA-160 in the Rio Vista Area',
  'Caltrans : Long-term construction on CA-160 Northbound and Southbound to CA-12 (Rio Vista). Alternate lanes open. One way 
   traffic control in effect.');
insert into ConstructionInfo values ('2016-05-06 4:17 PM', 'CA-152 Hecker Pass Project in Santa Clara County',
  'Caltrans : Long-term construction on CA-152 Eastbound and Westbound between Pole Line Rd (Gilroy) and Watsonville Rd (Gilroy).
   Alternate lanes open. One way traffic control in effect.');
insert into ConstructionInfo values ('2016-05-06 4:16 PM',
  'CA-121 Between CA-128 and Wooden Valley Rd in Napa County One-Way Traffic Control Due to Repairs for Roadway Erosion');
insert into ConstructionInfo values ('2016-05-06 4:15 PM',
  'CA-121 (Silverado Trail) Sarco Creek Bridge Replacement Project in Napa County');
insert into ConstructionInfo values ('2016-05-06 4:14 PM', 'US-101 San Francisquito Creek Bridge Replacement Project',
  'Caltrans : Long-term construction on US-101 Northbound north of Embarcadero Rd (Palo Alto). Auxiliary Lane closed.
   Expect delays.');
insert into ConstructionInfo values ('2016-05-06 4:13 PM',
  'US-101 Lane Closures Scheduled for the Marin - Sonoma County Narrows Project',
  'Caltrans : Long-term construction on US-101 Northbound north of Embarcadero Rd (Palo Alto). Auxiliary Lane closed.
   Expect delays.');
insert into ConstructionInfo values ('2016-05-06 4:12 PM', 'US-101 Interchange Project in Petaluma',
  'Caltrans : Long-term construction on US-101 Northbound north of Embarcadero Rd (Palo Alto). Auxiliary Lane closed.
   Expect delays.');
insert into ConstructionInfo values ('2016-05-06 4:11 PM', 'US-101 Broadway Interchange Project in Burlingame',
  'Caltrans : Long-term construction on US-101 Northbound north of Embarcadero Rd (Palo Alto). Auxiliary Lane closed.
   Expect delays.');
insert into ConstructionInfo values ('2016-05-06 4:10 PM',
  'I-80 / I-680 / CA-12 Interchange Project in Fairfield - Full Overnight Freeway Closures',
  'Caltrans : Long-term construction & Overnight roadwork on CA-12 Eastbound and Westbound between Ramal Rd (Unincorporated) and
   Napa Rd (Sonoma). Alternate lanes open. One way traffic control in effect.');
insert into ConstructionInfo values ('2016-05-06 4:09 PM', 'Weekend Closures of CA-4 Crosstown Freeway in Stockton');
insert into ConstructionInfo values ('2016-05-06 4:08 PM', 'VTA / BART Silicon Valley Berryessa Extension Project');
insert into ConstructionInfo values ('2016-05-06 4:07 PM',
  '29th Avenue Overcrossing in Oakland Closed from April 2015 to October 2016');
insert into ConstructionInfo values ('2016-05-06 4:06 PM',
  'Fairfield / Vacaville Train Station and Peabody Road Improvement Projects in Fairfield');


--Caltrans data inserts
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM084 WB 92 E. FOSTER CITY BLVD',
  'HALF MOON 25 MIN, SFO ARPT 10 MIN, PALO ALTO 24 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM079-SF101 N/B N/OF CANDLESTICK EXIT',
  'SF DWNTWN 30 MIN, OAKLAND 43 MIN, BERKELEY 62 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM091-CC 80 W/B W/OF Carquinez Bdg',
  'BERKELEY 37 MIN, SF DWNTWN 56 MIN, OAK ARPT 70 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM085-SM 92 E/B E/OF FOSTER CITY BLVD',
  'HAYWARD 24 MIN, CASTRO VY 37 MIN, FREMONT 37 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM070-ALA80 W/B W/OF RTE 13 (ASHBY AVE)',
  'SF DWNTWN 18 MIN, SFO ARPT 35 MIN, OAK ARPT 30 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM060-SM 84 E/B W/OF DUMBARTON BRG',
  'FREMONT 18 MIN, HAYWARD 50 MIN, MILPITAS 27 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM074 S880 N OF BROKAW RD',
  'S880/280 9 MIN, LOS GATOS 29 MIN, CUPERTINO 15 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM072-SM 92 W/B W/OF DE ANZA BLVD UC',
  'HALF MOON 20 MIN, DALY CITY 23 MIN, HWY 84 9 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM096-ALA24 W/B SHATTUCK AVE and 55th',
  'SF DWNTWN 20 MIN, SFO ARPT 36 MIN, OAK ARPT 31 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM122 SB101 Milbrae',
  'SAN JOSE 82 MIN,CALTRAIN 46 MIN, NEXT TRAIN 5:49');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM110-W580 JEO CASTRO VALLEY BLVD',
  'HWY 13 11 MIN, RTE 24 17 MIN, SM BRIDGE 23 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM126 EB 580 JWO SAN RAMON RD',
  'LIVERMORE 14 MIN, JCT 205 43 MIN, WALNUT CR 23 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM123 SM101 NOF 101/84 IC',
  'TRAVEL TIME(MIN) SF DOWNTOWN 69');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM098-ALA 880 N/B S/OF OAK ST.',
  'SF DWNTWN 16 MIN, CARQ BRDG 60 MIN, WALNUT CR 30 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM097-ALA 580 W/B ON CHETWOOD ST. O/C',
  'SF DWNTWN 19 MIN, CARQ BRDG 46 MIN, WALNUT CR 26 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM109 E580 JEO GRAND AVE',
  'DUBLIN 18 MIN, LIVERMORE 31 MIN, SM BRIDGE 21 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM103- W205 JEO JCT-580',
  'LIVERMORE 14 MIN, DUBLIN 21 MIN, CASTRO VY 33 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM051-SOL80 W/B E/of REDWOOD PKWAY',
  'HWY 4 7 MIN, BERKELEY 37 MIN, CONCORD 14 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM015-SM101 S/B S/OF BRITTAN AVE OFF',
  'PALO ALTO 18 MIN, RTE 237 30 MIN, FREMONT 40 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM012-SM101 N/B N/OF BROADWAY OC', 'TRAVEL TIME(MIN) SF DOWNTOWN 43');

insert into Caltrans values ('2016-05-06 5:22 PM', 'CM018-SCL 280 S/B N/OF FOOTHILL EXP',
  'LOS GATOS 35 MIN, MTN VIEW 7 MIN, SJ STATE 26 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM017-SCL 101 S/B S/OF EMBARCADERO RD OC',
  'SJ ARPT 30 MIN, MILPITAS 21 MIN, LOS GATOS 46 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM004-MRN 101 S/B S/OF DELONG AVE OC',
  'HWY 580 10 MIN, HWY 1 16 MIN, SEARS PT 39 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM003-MRN 101 N/B N/OF PACHECO CRK OC',
  'PETALUMA 33 MIN, ROHNRT PK 46 MIN, SEARS PT 42 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM011-SM101 S/B N/OF SIERRA PT RAMP OC',
  'SFO ARPT 7 MIN, RTE 92 18 MIN, RTE 84 30 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM010 -ALA 880 N/B N/OF INDUSTRIAL PKWY',
  'OAK ARPT 27 MIN, OAKLAND 34 MIN, CASTRO VY 26 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM019-SCL17 N/B N/OF LOS GATOS RD',
  'SJ ARPT 12 MIN, MILPITAS 22 MIN, MTN VIEW 15 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM030-ALA 880 S/B N/OF FREMONT BLVD',
  'MILPITAS 14 MIN, SJ ARPT 24 MIN, MENLO PRK 20 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM029-SOL80 W/B W/OF WEIGHT STATION',
  'CARQ BRDG 13 MIN, BERKELEY 50 MIN, CONCORD 20 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM042-SF101 N/B N/OF 23RD ST. OC',
  'TRSR ISL 21 MIN, OAKLAND 29 MIN, BERKELEY 47 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM040-SM 92 E/B E/of W. HILLSDALE BLVD',
  'SFO ARPT 17 MIN, SF DWNTWN 57 MIN, MENLO PRK 25 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM025-ALA24 E/B W/OF BROADWAY',
  'WALNUT CR 23 MIN, SAN RAMON 33 MIN, CONCORD 36 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM021-SCL 680 S/B S/OF SCOTT CREEK RD',
  'SJ STATE 24 MIN, CUPERTINO 33 MIN, S101 / 85 30 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM028-SF101 S/B N/OF Cesar Chavez St.',
  'SFO ARPT 11 MIN, RTE 92 23 MIN, DALY CITY 7 MIN');
insert into Caltrans values ('2016-05-06 5:22 PM', 'CM026-CC 24 W/B W/OF CAMINO PABLO RD',
  'OAKLAND 10 MIN, SF DWNTWN 25 MIN, OAK ARPT 35 MIN');
insert into Caltrans values ('2016-05-06 5:16 PM', 'CM001-MRN 101 N/B S/OF SIR FRANCIS DRAKE',
  'ACCIDENT W-80 AT GILMAN ST LANES BLOCKED');
insert into Caltrans values ('2016-05-06 5:16 PM', 'CM002-MRN 101 S/B S/OF SAN PEDRO RD UC',
  'ACCIDENT W-80 AT GILMAN ST LANES BLOCKED');
insert into Caltrans values ('2016-05-06 4:52 PM', 'CM090-CC 80 W/B E/OF APPIAN WAY',
  'ACCIDENT AT GILMAN ST LANES BLOCKED');
insert into Caltrans values ('2016-05-06 2:37 PM', 'CM036-SCL17 S/B S/OF SANTA CRUZ AVE', 'SLIPPERY/WET ROADWAY REDUCE SPEED');
insert into Caltrans values ('2016-05-06 2:37 PM', 'CM034-SCL17 N/B S/OF SUMMIT RD', 'SLIPPERY/WET ROADWAY REDUCE SPEED');
insert into Caltrans values ('2016-05-06 2:37 PM', 'CM037-SCR17 N/B S/OF GRANITE CRK RD OC', 'SLIPPERY/WET ROADWAY REDUCE SPEED');
insert into Caltrans values ('2016-05-06 2:37 PM', 'CM039-SCR17 S/B S/OF SUMMIT RD', 'SLIPPERY/WET ROADWAY REDUCE SPEED');
insert into Caltrans values ('2016-05-06 10:46 AM', 'CM513 S101 Before Battery Tunnel', 'SPEED LIMIT 35 MPH');
insert into Caltrans values ('2016-05-06 10:10 AM', 'CM006-CC 24 W/B W/OF LAFAYETTE STA UC',
  'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');
insert into Caltrans values ('2016-05-06 10:10 AM', 'CM155 NB880 NOF MARINA BLVD',
  'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');
insert into Caltrans values ('2016-05-06 10:10 AM', 'CM124 WB80 AT OLIVER RD', 'FREEWAY CLOSED W-80 SAN PABLO MAY 14 11 PM-7AM');

insert into Caltrans values ('2016-05-06 10:10 AM', 'CM153 E80 After YBI Tunnel',
  'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');
insert into Caltrans values ('2016-05-06 10:10 AM', 'CM154 E80 On Skyway', 'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');

insert into Caltrans values ('2016-05-06 10:10 AM', 'CM147 AMERICAN CANYON DR', 'FREEWAY CLOSED W-80 SAN PABLO MAY 14 11 PM-7AM');

insert into Caltrans values ('2016-05-06 10:10 AM', 'CM092-CC680 N/B S/OF RUDGEAR RD U/C',
  'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');
insert into Caltrans values ('2016-05-06 10:10 AM', 'CM069-ALA 880 N/B OVER 5TH ST',
  'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');
insert into Caltrans values ('2016-05-06 10:10 AM', 'CM078-ALA80 E/B E/OF UNIVERSITY AVE',
  'FREEWAY CLOSED E-80 SAN PABLO MAY 14 11 PM-7AM');
insert into Caltrans values ('2016-05-06 6:40 AM', 'CM007 at NB238', 'BART TRACK THIS WEEKEND INFO - BART.GOV');

insert into Caltrans values ('2016-05-06 6:40 AM', 'CM125 S238 JNO ASHLAND', 'BART TRACK THIS WEEKEND INFO - BART.GOV');

insert into Caltrans values ('2016-05-06 6:40 AM', 'CM077 NB 880 JNO DIXON LANDING RD',
  'BART TRACK THIS WEEKEND INFO - BART.GOV');


--News data inserts
insert into News values ('2016-05-06 4:25 PM', 'Caltrans Construction on CA-17 Near Scotts Valley', null);
insert into News values ('2016-05-06 4:24 PM', 'Posey Tube Closures Scheduled for Overnight Maintenance', null);
insert into News values ('2016-05-06 4:23 PM', 'I-80 / San Pablo Dam Road Interchange Overnight Closure May 14 and 15',
  '2016-05-06 4:10 PM');
insert into News values ('2016-05-06 4:22 PM',
  'Get Current Road Conditions to Reno/Lake Tahoe and Outside the Bay Area from Caltrans', null);
