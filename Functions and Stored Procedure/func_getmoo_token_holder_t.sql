CREATE OR REPLACE FUNCTION public.func_getmoo_token_holder_t(in_address character varying)
 RETURNS TABLE("Address" character varying, "Index" bigint, "Amount" character varying, "Proof" character varying)
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
	--- Error occurs in replace(coin_name,'celo','CELO') --- 

	--(select address,indx,amount,proof_array 
	--from tbl_moo_token_user_base
	--where address=in_address  --and deposited <> 0
	---and enabled=true
	--limit 1);

	--(select "tbl_moo_token_user_base.address" as out_address,
	(select address,
	indx,
	amount,
	proof_array
	from tbl_moo_token_user_base
	where address=in_address  --and deposited <> 0
	limit 1);

	------------------- Code Ends Here ---------------------
	
END;
$function$
;
