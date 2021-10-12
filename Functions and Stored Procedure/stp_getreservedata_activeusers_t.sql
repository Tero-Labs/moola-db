CREATE OR REPLACE PROCEDURE public.stp_getreservedata_activeusers_t(INOUT out_activeusers numeric DEFAULT 0)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	-- Created DateTime 24th May 2021 - Monday -- 
	-- Author: Mohammad Abdur Rahman --

	-- Required Tables -> tbl_user
	-- CORE SQL - SELECT distinct count(address) FROM tbl_user
	

	------------------- Code Starts Here ---------------------
	--- Activeusers
	---select count(distinct address) into out_activeusers from tbl_user_account;   --- where enabled=True;

	--- 23rd July 2021 - Friday --- To migitate the ubeswap users (Tahlil's)
	select count(distinct address) into out_activeusers from tbl_user_account where agent_id ='0';   --- where enabled=True;

------------------- Code Ends Here ---------------------
END;
$procedure$
;
