CREATE PROCEDURE Super_class (in TS varchar(255))
comment '�� ����� ����� �����' LANGUAGE SQL NOT DETERMINISTIC MODIFIES SQL DATA SQL SECURITY DEFINER
begin

/*--- ������ �� ��  call Super_class(CONCAT(@prompt('���� ��','A',, multi, free))) ---*/

/*--------------- ���� ��� ������������ ���������� ������ �� � ��� ������ �� �� ��������� ������� ---------------*/
declare a int;
declare  TS_string varchar(255) default ' ';
declare TS_one varchar(255);
declare  aloop int;
declare TS_semicolons varchar(255);
/*--- ��������� ������� ---*/
CREATE TEMPORARY TABLE TS_tab(
    Number_id INT  default 1 ,
    TS_arr varchar(255) );

set TS_semicolons = replace(TS,'�',';�');
set TS_semicolons = RIGHT( TS_semicolons, character_length(TS_semicolons) - 1  );
set TS = TS_semicolons;
SELECT (CHAR_LENGTH(TS) - CHAR_LENGTH(REPLACE(TS,';',''))) div CHAR_LENGTH(';')  into a;
set aloop = a + 1;
WHILE aloop > 0 DO
	set TS_string = concat(TS_string,'\'', REPLACE(SUBSTRING(SUBSTRING_INDEX(TS, ';', aloop),
		CHAR_LENGTH(SUBSTRING_INDEX(TS, ';', aloop -1)) + 1),';', "") ,'\',');
	set TS_one = REPLACE(SUBSTRING(SUBSTRING_INDEX(TS, ';', aloop),CHAR_LENGTH(SUBSTRING_INDEX(TS, ';', aloop -1)) + 1),';', "");
    INSERT INTO TS_tab (Number_id,TS_arr) VALUES (aloop,TS_one); /* -- ������ ��(��) � TS_arr*/
    SET aloop = aloop - 1;    
END WHILE;

set TS_string = trim(TS_string);
set TS_string = SUBSTRING(TS_string, 1, character_length(TS_string) - 1 );

/* --------------- ��� ������ --------------- */
/* -- select TS_string as 'right_prompt_string' ,a as 'a',aloop as 'aloop'; -- ����� ������ ��(��) � �������� ������  */
/* -- select * from TS_tab -- */

/* --------------- ������ ��� "�� ����� ����� �����" ������� --------------- */
select item_ref_query.item_num ,  concat('<a href="', concat('mailto:',item_ref_query.email) ,'">',item_ref_query.prod_manager_name2,'</a>') as ������_��� 
from (
    select item_num, ITEM_TS,email, ifNull(zam_logista,prod_manager_name) as prod_manager_name2 
    from item_ref
    where ITEM_TS in (select TS_tab.TS_arr from TS_tab)) item_ref_query ;
 
DROP TEMPORARY TABLE TS_tab; 
end


    