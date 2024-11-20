select * from plant order by 1;

delete from plant where plant_id = -1;

insert into plant (plant_id, plant_name, feature, plant_groth, standard_temp, standard_hum, standard_soil, food)
values (12, '가지', '보라색 껍질을 가진 채소로, 다양한 요리에 사용됩니다.
가지는 비타민 C, 비타민 K, 칼륨, 섬유질이 풍부하며, 칼로리가 낮고 수분 함량이 높아 다이어트에 좋습니다.
맛은 부드럽고 약간 쓴맛이 있지만 조리 후에는 식감이 부드럽고 풍미가 깊어집니다.
가지는 구이나 볶음, 찜, 튀김 등 다양한 요리에 활용됩니다.', '70 ~ 90일', '27.5', '0.65', '0.6', '가지 나물, 가지 구이, 가지 튀김, 가지 파스타, 가지 볶음, 가지 무사카, 가지 라타투이, 가지 피자' );


s


SELECT standard_temp, standard_hum, image_path, plant_name
    FROM plant
    WHERE plant_id = 4;

select * from plant where plant_id not in( select plantid_log from userplant where userid_log = '5' and plantid_log is not null);

commit;

rollback;

select * from water_manage;

insert into member (name, userid, );

select * from plant;

SELECT * FROM all_cons_columns 
WHERE constraint_name = 'SYS_C008624';
select * from member;

delete from member where role != 'ADMIN' and userid != '1';

rollback;

select * from plants_log;

delete from plants_log where not(userid = '1');

delete from plants_data where mac_address = 'EE:40:A3:3A:E3:44';

delete from userplant where mac_address = 'EE:40:A3:3A:E3:44';

select id, title, writedate, writer from notice;

rollback;

commit;

update notice set writedate = '24/11/13' where id = '335';

drop table  water_manage;

rollback;

select * from plant;



select * from userplant;

select * from plant where plant_id not in( select plantid_log from userplant where userid_log = '3') order by 1;

drop table devi
DELETE FROM userplant WHERE userid_log = 3 AND plantid_log = 3;
ALTER TABLE member DROP CONSTRAINT SYS_C008536;
CREATE TABLE userplant (
    userid_log VARCHAR2(50) NOT NULL,    -- Member 테이블의 userid
    plantid_log number NOT NULL,           -- Plant 테이블의 plant_id
    register_date date default sysdate,     -- 등록날짜
    PRIMARY KEY (userid_log, plantid_log),
    FOREIGN KEY (userid_log) REFERENCES member(userid) ON DELETE CASCADE,
    FOREIGN KEY (plantid_log) REFERENCES plant(plant_id)
);


commit;

select * from plant
where plant_id not in( select plantid_log from userplant where userid_log = '5' and plantid_log is not null);


ALTER TABLE device_plant
DROP CONSTRAINT SYS_C008535;

ALTER TABLE userplant
ADD CONSTRAINT fk_plantid_log
FOREIGN KEY (plantid_log) REFERENCES plant(plant_id) 
ON DELETE CASCADE;

SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name = 'USERPLANT' AND constraint_type = 'R';

 SELECT mac_address, temperature, humid, bright, moisture, to_char(time_log, 'HH24:MI') as time_log 
    FROM plants_log
    WHERE userid ='1' and plant_id = 8
    ORDER BY mac_address DESC 
    FETCH FIRST 10 ROWS ONLY;
  SELECT p.plant_id AS plantid_log, p.plant_name, TRUNC(SYSDATE) - TRUNC(up.register_date)+1 AS today
    FROM userplant up
    JOIN plant p ON up.plantid_log = p.plant_id
    WHERE up.userid_log = '5' AND up.plantid_log = 11;
    
    
select * from userplant where userid_log is null;
update table userplant add register_date date default sysdate;

select * from plants_log order by log_numb desc;
ALTER TABLE userplant RENAME COLUMN plant_id TO plantid_log;
ALTER TABLE device rename COLUMN userid TO userid_log;
ALTER TABLE device RENAME TO userplant;
select plant_id, plant_name from plant;
select * from userplant;
select * from water_manage;

update userplant set device_numb = 3 where mac_address= '1C:BB:A5:24:3F:71';


select * from userplant;

insert into userplant (mac_address, userid_log, plantid_log)
values('1C:BB:A5:24:3F:71', '1', 5  );


commit;
delete from plants_data;

select * from plants_data order by time_log desc;
select * from plants_log order by time_log desc;
delete from ;

commit;

select diary_id, diary_writedate, diary_title  from diary;

update diary set diary_writedate = '24/11/3' where diary_id = '893';

 SELECT 
        p.plant_id AS plantid_log, 
        p.plant_name, 
        TRUNC(SYSDATE) - TRUNC(up.plant_date) + 1 AS today
    FROM 
        userplant up
    JOIN 
        plant p ON up.plantid_log = p.plant_id
     WHERE 
        up.userid_log = '1' 
        AND up.plantid_log = 4;

update userplant set plant_date = register_date where userid_log = '1' and plantid_log = 4;


commit;


select * from plants_log order by time_log desc;
commit;
delete from plants_logs_select where plant_id = 12;
CC:50:E3:3E:D3:44(String), test02(String);
select count(*) from userplant where mac_address = 'CC:50:E3:3E:D3:44' and userid_log = 'star';

delete from plants_data where plant_id = 6 and userid = '1';

select log_numb, temperature, humid, bright, moisture
	from plants_data
	where  userid = '5' and plant_id = 11
	ORDER BY log_numb DESC 
    FETCH FIRST 1 ROWS ONLY;


select * from plant ;

select plant_id, plant_name
from plant p left outer join userplant d on p.plant_id = d.plantid_log
where d.plantid_log = 2;

select plant_id, plant_name
from plant p left outer join userplant d on p.plant_id = d.plantid_log
where p.plant_id not in (select plantid_log from userplant where userid_log = '5' and plantid_log is not null );

SELECT p.*
    FROM Plant p
    INNER JOIN userplant u ON p.plant_id = u.plantid_log
    WHERE u.userid_log = '5' and mac_address = 'CC:50:E3:3E:D3:44';
     --WHERE u.userid_log = '5' and mac_address = 'AA:50:E3:3E:D3:44';
--CC:50:E3:3E:D3:44 null
--AA:50:E3:3E:D3:44  2
insert into plants_logs_select( log_numb, mac_address, temperature, humid, bright, moisture, time_log,cctv,userid,plant_id   )
values(  4, 'E0:98:06:13:5D:75', 33, 25, 500, 74, to_date('24-11-04 13:00', 'yy-mm-dd hh24:mi'), sysdate, '1', 8 );

select * from plants_log
	where userid = '1' and plant_id = 12;

drop table device;
create table userplant (
    device_numb	number constraint device_numb_pk primary key,
    mac_address VARCHAR2(20) NULL,
    userid_log VARCHAR2(50) null,
    plantid_log number null,
    register_date date default sysdate,
     FOREIGN KEY (userid) REFERENCES member(userid) ON DELETE CASCADE,
    FOREIGN KEY (plant_id) REFERENCES plant(plant_id) ON DELETE CASCADE
);

update userplant
set mac_address = '8C:AA:B5:F0:BC:DD' where device_numb = 3;


commit;
select * from userplant;

select count(*) from userplant 
where userid_log = '1' and plantid_log is not null;
select * from userplant;
select * from plant; 
where plant_id 
 not in( select plantid_log from userplant where userid_log = '2' and plantid_log is null);
 
 select * from plant 
where plant_id 
 not in( select plantid_log from userplant where userid_log = '1' and plantid_log is not null);

update userplant set plantid_log = null;
commit;
insert into userplant(mac_address, register_date)
values ('EE:40:A3:3A:E3:44', sysdate)
;
commit;

insert into plants_log(mac_address, temperature, humid, bright, moisture, userid,plant_id, light, relay1, relay2, relay3, relay4   ) values(?,  ?, ?, ?, ?,  (select userid from device where mac_address = ?),  (select plant_id from device where mac_address = ?), ?, ?, ?, ?, ?)
select mac_address, temperature, humid, bright, moisture, userid,plant_id, light, relay1, relay2, relay3, relay4   ) values(?,  ?, ?, ?, ?,  (select userid from device where mac_address = ?),  (select plant_id from device where mac_address = ?), ?, ?, ?, ?, ?)
from plants_log;

rename plants_logs_update to plants_data;

create sequence seq_device start with 1 increment by 1 nocache;

create or replace trigger trg_device 
    before insert on device
    for each row
begin
    select seq_device.nextval into :new.device_numb from dual;
end;
/
select to_char(time_log, 'yy/mm/dd hh24:mi:ss') time, d.* from plants_data d;
--id          number constraint notice_id_pk primary key, /* PK */

--truncate table plants_data;

select count(*) from plants_data 
    where mac_address ='CC:50:E3:3E:D3:44' and userid = (select userid_log from userplant where mac_address = 'CC:50:E3:3E:D3:44');

create or replace procedure pr_plants_data (p_mac_address varchar2, p_temperature NUMBER, p_humid NUMBER
                                            , p_moisture NUMBER)
is 
   v_rows NUMBER := 0;
begin
    select count(*) into v_rows from plants_data 
    where mac_address = p_mac_address and userid = (select userid_log from userplant where mac_address = p_mac_address)
    ;
    
    if( v_rows = 0 ) then
         insert into plants_data(mac_address, temperature, humid, moisture, userid,plant_id   )
        values( p_mac_address,  p_temperature, p_humid, p_moisture
        ,  (select userid_log from userplant where mac_address = p_mac_address),
         (select plantid_log from userplant where mac_address = p_mac_address) );
       
    else
        update plants_data 
        set mac_address=p_mac_address, temperature=p_temperature, humid=p_humid,  moisture=p_moisture
            , time_log = sysdate,
              plant_id = (select plantid_log from userplant where mac_address = p_mac_address)
        where mac_address = p_mac_address;
    
    end if;    
    
end;
/
-- plant_id = (select plantid_log from userplant where mac_address = p_mac_address) 추가함
select to_char(time_log, '24hh:mi') time_log from plants_log order by time_log desc;
CREATE TABLE plants_data (
    log_numb number GENERATED BY DEFAULT AS IDENTITY CONSTRAINT  plants_logs_select_pk PRIMARY KEY,
    mac_address VARCHAR2(20) NULL,
	temperature	NUMBER(3, 1)	NULL,
	humid	NUMBER(3, 1)	NULL,
	bright	number	NULL,
	moisture	NUMBER(3, 1)	NULL,
	time_log	date default sysdate,
	cctv	date NULL,
    userid  varchar(50) not null,
    plant_id    number  not null,
    light VARCHAR2(20),
    RELAY1  VARCHAR2(20),
    RELAY2  VARCHAR2(20),
    RELAY3  VARCHAR2(20),
    RELAY4  VARCHAR2(20)
    FOREIGN KEY (userid) REFERENCES member(userid),
    foreign key (plant_id) references plant(plant_id)
);
alter table plants_data drop column CCTV;

alter table plants_logs_UPDATE add (
    light VARCHAR2(20),
    RELAY1  VARCHAR2(20),
    RELAY2  VARCHAR2(20),
    RELAY3  VARCHAR2(20),
    RELAY4  VARCHAR2(20)
);

commit;

alter table plants_data modify (
    light default 'OFFOO' 
);
서울 성북구 안암로 5 (대광초등학교)
post, address1,
02859
select * from member where userid = '1';

update member set address1 = '서울 성북구 안암로 5 (대광초등학교)' where userid = '1';

select plant_id,userid,to_char(time_log, 'yy-mm-dd hh24:mi') as time_log from plants_log
where userid = '1' and plant_id = 8
order by time_log desc;

commit;

select to_char(sysdate, 'yy-mm-dd hh24')|| ':' || '00' , 
 to_char(to_date(to_char(to_date('24-11-04 13' + 2*0.5/24), 'yy-mm-dd hh24')|| ':' || '00', 'yy-mm-dd hh24:mi' ), 'yy-mm-dd hh24:mi'), 
'2024-11-04 ' || substr (to_char(1300 + 2*30), 0,2) || ':' || substr (to_char(1300 + 2*30), 3) 
from dual;

CREATE TABLE plants_log (
	log_numb	number constraint plants_logs_update_pk primary key,
    mac_address VARCHAR2(20) NULL,
	temperature	NUMBER(3, 1)	NULL,
	humid	NUMBER(3, 1)	NULL,
	bright	number	NULL,
	moisture	NUMBER(3, 1)	NULL,
	time_log	date default sysdate,
    userid  varchar(50) not null,
    plant_id    number  not null,
    FOREIGN KEY (userid) REFERENCES member(userid),
    foreign key (plant_id) references plant(plant_id)
);

create sequence seq_logs_update start with 1 increment by 1 nocache;

create or replace trigger trg_logs_update 
    before insert on plants_logs_update
    for each row
begin
    select seq_logs_update.nextval into :new.log_numb from dual;
end;
/

CREATE TABLE water_manage (
    water_numb number constraint water_manage_pk primary key,
	waterdate	DATE default sysdate NULL,
	soilmoisture	NUMBER(3, 1)	NULL,
    plant_id        number      not null,
    userid          varchar2(50) not null,
    FOREIGN KEY (plant_id) REFERENCES plant(plant_id),
    FOREIGN KEY (userid) REFERENCES member(userid)
);

create sequence seq_water start with 1 increment by 1 nocache;
create or replace trigger trg_water 
    before insert on water_manage
    for each row
begin
    select seq_water.nextval into :new.water_numb from dual;
end;
/

select * from water_manage order by water_numb desc;

select plant_id, plant_name from plant;    
      
      
select * from member;      
      
      
SELECT 
        p.plant_id AS plantid_log, 
        p.plant_name, 
        TRUNC(SYSDATE) - TRUNC(up.plant_date) + 1 plant_date
    FROM 
        userplant up
    JOIN 
        plant p ON up.plantid_log = p.plant_id
     WHERE 
        up.userid_log = '1'
        AND up.plantid_log = 4;
        
        //사용자가 선택한 작물의 이름
SELECT p.plant_name, u.plant_date
FROM plant p
JOIN userplant u ON p.plant_id = u.plantid_log
WHERE u.userid_log = '1' AND u.plantid_log = 4; 

SELECT p.plant_name,  TRUNC(SYSDATE) - TRUNC(u.plant_date) + 1 today
FROM plant p
JOIN userplant u ON p.plant_id = u.plantid_log
WHERE u.userid_log = '1' AND u.plantid_log = 4;