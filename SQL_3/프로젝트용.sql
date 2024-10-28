select * from plant order by 1;

delete from plant where plant_id = -1;

insert into plant (plant_id, plant_name, feature, plant_groth, standard_temp, standard_hum, standard_soil, food)
values (12, '가지', '보라색 껍질을 가진 채소로, 다양한 요리에 사용됩니다.
가지는 비타민 C, 비타민 K, 칼륨, 섬유질이 풍부하며, 칼로리가 낮고 수분 함량이 높아 다이어트에 좋습니다.
맛은 부드럽고 약간 쓴맛이 있지만 조리 후에는 식감이 부드럽고 풍미가 깊어집니다.
가지는 구이나 볶음, 찜, 튀김 등 다양한 요리에 활용됩니다.', '70 ~ 90일', '27.5', '0.65', '0.6', '가지 나물, 가지 구이, 가지 튀김, 가지 파스타, 가지 볶음, 가지 무사카, 가지 라타투이, 가지 피자' );

commit;

select * from member;

select * from plant;

drop table plants_logs_update;

select * from userplant;

select * from plant where plant_id not in( select plantid_log from userplant where userid_log = '3') order by 1;


DELETE FROM userplant WHERE userid_log = 3 AND plantid_log = 3;

CREATE TABLE userplant (
    userid_log VARCHAR2(50) NOT NULL,    -- Member 테이블의 userid
    plantid_log number NOT NULL,           -- Plant 테이블의 plant_id
    register_date date default sysdate,     -- 등록날짜
    PRIMARY KEY (userid_log, plantid_log),
    FOREIGN KEY (userid_log) REFERENCES member(userid) ON DELETE CASCADE,
    FOREIGN KEY (plantid_log) REFERENCES plant(plant_id)
);
alter table userplant add register_date date default sysdate;

--id          number constraint notice_id_pk primary key, /* PK */
CREATE TABLE plants_logs_select (
	log_id	number	constraint plants_logs_select_pk primary key,
	temperature	NUMBER(3, 1)	NULL,
	humid	NUMBER(3, 1)	NULL,
	bright	number	NULL,
	moisture	NUMBER(3, 1)	NULL,
	time_log	DATE	NULL,
	cctv	date NULL,
	planting_date	DATE	NULL,
	plant_id	number	NOT NULL
);

CREATE TABLE plants_logs_update (
	log_id	number constraint plants_logs_update_pk primary key,
	temperature	NUMBER(3, 1)	NULL,
	humid	NUMBER(3, 1)	NULL,
	bright	number	NULL,
	moisture	NUMBER(3, 1)	NULL,
	time_log	DATE	NULL,
	cctv	number	NULL,
	planting_date	DATE	NULL,
	plant_id	number	NOT NULL
);

CREATE TABLE water_manage (
    water_id number constraint water_manage_pk primary key,
	waterdate	DATE	NULL,
	soilmoisture	NUMBER(3, 1)	NULL,
	plant_id	number	NOT NULL
);



SELECT * FROM userplant WHERE plantid_log = 4;

SELECT 
    TRUNC(SYSDATE) - TRUNC(register_date)+1 AS day
FROM 
    userplant
WHERE 
    userid_log = '1'
    AND plantid_log = 12;