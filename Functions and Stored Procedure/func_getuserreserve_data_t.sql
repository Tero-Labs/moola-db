CREATE OR REPLACE FUNCTION public.func_getuserreserve_data_t(in_address character varying, in_currency character varying)
 RETURNS TABLE("assetCurrency" character varying, "depositAmount" numeric, "depositValue" numeric, "depositInterest" numeric, "borrowAmount" numeric, "borrowValue" numeric, "debtAmount" numeric, "debtValue" numeric, "borrowMode" character varying, "borrowInterest" numeric, "originationFeeAmount" numeric, "originationFeeValue" numeric, "availableToBorrowAmount" numeric, "availableToBorrowValue" numeric, "isCollateral" boolean)
 LANGUAGE plpgsql
AS $function$
declare

---------------
temp_availableToBorrowAmount numeric;
temp_availableToBorrowValue numeric;
---------------


BEGIN
	-- Created DateTime 29th July 2021 - Thrusday -- 
	-- Author: Mohammad Abdur Rahman --
	
	select available_borrows_eth ,func_getexchange_rate_celo_to_x_t(in_currency,available_borrows_eth) --func_getexchange_rate_celo_to_x_nearest_past(in_currency,available_borrows_eth,block_number)
	
	INTO
	
	temp_availableToBorrowAmount , temp_availableToBorrowValue
	
	from tbl_user_account
	where address=in_address --and coin_name = 'Celo'--in_currency
	--and enabled=true
	order by block_number desc limit 1;
	
	
	return QUERY
	------------------- Code Starts Here ---------------------
	
	(
	select 
	coin_name,
	deposited, func_getexchange_rate_celo_to_x_t(in_currency,deposited),
	liquidity_rate,
	borrowed,func_getexchange_rate_celo_to_x_t(in_currency,borrowed),
	debt, func_getexchange_rate_celo_to_x_t(in_currency,debt),
	rate_mode,
	borrow_rate,
	origination_fee,func_getexchange_rate_celo_to_x_t(in_currency,origination_fee),
	temp_availableToBorrowAmount, --- Different in Celo 
	temp_availableToBorrowValue,
	is_collateral
	
	from tbl_user_reserve
	where address=in_address and coin_name = 'Celo'--in_currency
	--and enabled=true
	order by block_number desc limit 1
	 )
	 
	 union 
	 
	 (
	select 
	coin_name,
	deposited, func_getexchange_rate_cusd_to_x_t(in_currency,deposited),
	liquidity_rate,
	borrowed,func_getexchange_rate_cusd_to_x_t(in_currency,borrowed),
	debt, func_getexchange_rate_cusd_to_x_t(in_currency,debt),
	rate_mode,
	borrow_rate,
	origination_fee,func_getexchange_rate_cusd_to_x_t(in_currency,origination_fee),
	func_getexchange_rate_celo_to_cusd_t(temp_availableToBorrowAmount),--temp_availableToBorrowAmount,
	temp_availableToBorrowValue,
	is_collateral
	
	from tbl_user_reserve
	where address=in_address and coin_name = 'cUSD'--in_currency
	--and enabled=true
	order by block_number desc limit 1
	 )
	 
	 union 
	 
	 (
	select 
	coin_name,
	deposited, func_getexchange_rate_ceur_to_x_t(in_currency,deposited),
	liquidity_rate,
	borrowed,func_getexchange_rate_ceur_to_x_t(in_currency,borrowed),
	debt, func_getexchange_rate_ceur_to_x_t(in_currency,debt),
	rate_mode,
	borrow_rate,
	origination_fee,func_getexchange_rate_ceur_to_x_t(in_currency,origination_fee),
	func_getexchange_rate_celo_to_ceur_t(temp_availableToBorrowAmount),--temp_availableToBorrowAmount,
	temp_availableToBorrowValue, --func_getexchange_rate_celo_to_ceur(temp_availableToBorrowValue),--temp_availableToBorrowValue,
	is_collateral
	
	from tbl_user_reserve
	where address=in_address and coin_name = 'cEUR'--in_currency
	--and enabled=true
	order by block_number desc limit 1
	 )
	 
	 ;
	 
	 
	------------------- Code Ends Here ---------------------
	
END;
$function$
;
