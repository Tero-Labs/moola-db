CREATE OR REPLACE FUNCTION public.func_getuseraccountinfo_borrow(in_address character varying)
 RETURNS TABLE(currency character varying, amount numeric, interest numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
	-- Created DateTime 26th May 2021 - Monday -- 
	-- Author: Mohammad Abdur Rahman --
	
	-- Function - Find the maximum value of supplied activityType=[deposit, withdraw, borrow, repay] on a address
	
	-- Required Tables -> tbl_user_account
	-- CORE SQL - 
	

	return QUERY
	------------------- Code Starts Here ---------------------
	--- SQL should be stacked one where = 'celo' AND borrow <> 0 ORDER by creation_datetime DESC LIMIT 1 etc 
	(select coin_name,borrowed,borrow_rate 
	from tbl_user_reserve
	where address=in_address and coin_name = 'Celo' 
	--and enabled=true
	order by block_number desc limit 1)
	
	union
	
	(select coin_name,borrowed,borrow_rate 
	from tbl_user_reserve
	where address=in_address and coin_name = 'cUSD'
	--and enabled=true
	order by block_number desc limit 1)
	
	union 
	
	(select coin_name,borrowed,borrow_rate 
	from tbl_user_reserve
	where address=in_address and coin_name = 'cEUR'
	--and enabled=true
	order by block_number desc limit 1);
	------------------- Code Ends Here ---------------------
	
END;
$function$
;
