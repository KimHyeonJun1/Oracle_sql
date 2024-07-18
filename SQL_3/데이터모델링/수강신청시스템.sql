CREATE TABLE "Student" (
	"id"	NUMBER(8)		NOT NULL,
	"name"	VARCHAR2(50)		NULL,
	"height"	NUMBER(3)		NULL,
	"address"	VARCHAR2(100)		NULL,
	"phone"	VARCHAR2(11)		NULL,
	"email"	VARCHAR2(50)		NULL,
	"dept_id"	NUMBER(4)		NULL
);

CREATE TABLE "Professor" (
	"id"	NUMBER(4)		NOT NULL,
	"name"	VARCHAR2(50)		NULL,
	"major"	VARCHAR2(50)		NULL,
	"dept_id"	NUMBER(4)		NULL,
	"email"	VARCHAR2(50)		NULL,
	"phone"	NUMBER(11)		NULL
);

CREATE TABLE "Student_course" (
	"Key"	VARCHAR2(50)		NOT NULL,
	"id"	NUMBER(8)		NOT NULL,
	"id2"	NUMBER(3)		NOT NULL
);

CREATE TABLE "Course" (
	"course_id"	NUMBER(3)		NOT NULL,
	"name"	VARCHAR2(50)		NULL,
	"professor_name"	VARCHAR2(50)		NULL,
	"date"	DATE		NULL,
	"score"	NUMBER(1)		NULL,
	"datetime"	NUMBER(1)		NULL
);

CREATE TABLE "Curriculum" (
	"Key"	VARCHAR(255)		NOT NULL,
	"id"	NUMBER(4)		NOT NULL,
	"id2"	NUMBER(3)		NOT NULL,
	"date"	DATE		NULL,
	"status"	BOOLEAN		NULL
);

ALTER TABLE "Student" ADD CONSTRAINT "PK_STUDENT" PRIMARY KEY (
	"id"
);

ALTER TABLE "Professor" ADD CONSTRAINT "PK_PROFESSOR" PRIMARY KEY (
	"id"
);

ALTER TABLE "Student_course" ADD CONSTRAINT "PK_STUDENT_COURSE" PRIMARY KEY (
	"Key",
	"id",
	"id2"
);

ALTER TABLE "Course" ADD CONSTRAINT "PK_COURSE" PRIMARY KEY (
	"course_id"
);

ALTER TABLE "Curriculum" ADD CONSTRAINT "PK_CURRICULUM" PRIMARY KEY (
	"Key",
	"id",
	"id2"
);

ALTER TABLE "Student_course" ADD CONSTRAINT "FK_Student_TO_Student_course_1" FOREIGN KEY (
	"id"
)
REFERENCES "Student" (
	"id"
);

ALTER TABLE "Student_course" ADD CONSTRAINT "FK_Course_TO_Student_course_1" FOREIGN KEY (
	"id2"
)
REFERENCES "Course" (
	"course_id"
);

ALTER TABLE "Curriculum" ADD CONSTRAINT "FK_Professor_TO_Curriculum_1" FOREIGN KEY (
	"id"
)
REFERENCES "Professor" (
	"id"
);

ALTER TABLE "Curriculum" ADD CONSTRAINT "FK_Course_TO_Curriculum_1" FOREIGN KEY (
	"id2"
)
REFERENCES "Course" (
	"course_id"
);

