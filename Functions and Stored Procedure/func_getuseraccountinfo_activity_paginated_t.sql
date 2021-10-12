CREATE OR REPLACE FUNCTION public.func_getuseraccountinfo_activity_paginated_t(in_address character varying, in_currency character varying, in_page_no numeric DEFAULT 0, in_page_size numeric DEFAULT 20)
 RETURNS TABLE(type character varying, source character varying, "originationFeeAmount" numeric, "originationFeeValue" numeric, "healthFactor" numeric, "liquidationPrice" numeric, "amountOfDebtRepaid" numeric, "amountOfDebtRepaidValue" numeric, "liquidatorClaimed" numeric, "liquidatorClaimedValue" numeric, "penaltyPercentage" numeric, currency character varying, amount numeric, value numeric, "timestamp" double precision, status text, "transactionId" character varying, "claimedCurrency" character varying)
 LANGUAGE plpgsql
AS $function$
declare

---temp_health_factor numeric;
out_health_factor numeric :=0;
temp_penaltyPercentage numeric;
BEGIN
	-- Created DateTime 27th May 2021 - Thrusday -- 
	-- Author: Mohammad Abdur Rahman --
	
	-- Function - Find the maximum value of supplied activityType=[deposit, withdraw, borrow, repay] on a address
	
	-- Required Tables -> tbl_user_account
	-- CORE SQL - 
	
	----- Todo 
	----- ### Health Factor ### ----- DONE 
	--- 1. health_factor: -
	--- if action== 'liquidate':
	--- health factor from db

	--- if action == 'borrow' or 'repay':
	--- health_factor = 1 / liquidation_base_price (need to check division by zero)

	---------------------------------
	
	----- Paganation 
	
	------ 2th July - Monday --
	----- Join on 2nd ext table --
	----- Add origination_fee_in_celo , origination_fee_in_cusd , origination_fee_in_ceur
	
	---- 15th August 2021,Sunday ---- 
	--select 'penaltyPercentage' into temp_penaltyPercentage from tbl_config_lookup where item = 'PenaltyPercentage' order by creation_datetime limit 1; 
	select item_value into temp_penaltyPercentage from  tbl_config_lookup where item = 'penaltyPercentage' order by creation_datetime desc limit 1;


	return QUERY 
	------------------- Code Starts Here ---------------------
	--- where to place "claimedCurrency" character varying from current last field , does it needs to be re-oriented ???
	
	(
	select tbl_user_activity.activity_type, -- "type" 
	address, -- "source"
	tbl_user_activity_ext_origin_fee.origination_fee_in_celo ,--( select tbl_user_activity_ext_origin_fee.origination_fee_in_celo from tbl_user_activity_ext_origin_fee where  tbl_user_activity_ext_origin_fee.tx_hash=tbl_user_activity.tx_hash limit 1 ) celooriginamount , ---0.0, -- "originationFeeAmount"
	func_getexchange_rate_celo_to_x_nearest_past_t(in_currency, tbl_user_activity_ext_origin_fee.origination_fee_in_celo ,tbl_user_activity.block_number) , ---func_getexchange_rate_celo_to_x_nearest_past_t(in_currency,celooriginamount,block_number), --celooriginamount ---0.0, -- "originationFeeValue"
	--- # # --- 
	case ---"healthfactor"
          WHEN tbl_user_activity.activity_type = 'liquidate' THEN
               health_factor
          WHEN ((tbl_user_activity.activity_type='borrow' or tbl_user_activity.activity_type='repay') and  (liquidation_price_base <> 0 )) THEN
    	   		1 / liquidation_price_base 
          else 
           	    0
    END ,
	--- # # ---
	amount_of_debt_repaid / NULLIF( tbl_user_activity.amount, 0) , --- "liquidationPrice"  ---NULLIF to prevent div by 0 error  ---
	amount_of_debt_repaid , -- "amountOfDebtRepaid"
	func_getexchange_rate_celo_to_x_nearest_past_t(in_currency,amount_of_debt_repaid,tbl_user_activity.block_number), -- "amountOfDebtRepaidValue"
	(tbl_user_activity.amount), --- liquidatorClaimed -- 
	 CASE --- "liquidatorClaimedValue" 
		WHEN claimed_currency is not null then
			func_getexchange_rate_y_to_x_t( tbl_user_activity.claimed_currency , in_currency , tbl_user_activity.amount)
	 END ,
	--(select liquidation_discount from tbl_reserve_configuration where tbl_reserve_configuration.coin_name ='Celo' order by block_number desc limit 1), -- 0.0, -- "penaltyPercentage"
	temp_penaltyPercentage, --PenaltyPercentage, 15Aug21
	coin_name, -- "currency"
	(tbl_user_activity.amount) as out_amount, -- "amount" 
	func_getexchange_rate_celo_to_x_nearest_past_t(in_currency,tbl_user_activity.amount,tbl_user_activity.block_number), -- "value" 
	date_part('epoch', tbl_user_activity.tx_timestamp) as tx_tmstamp , -- "timestamp"
	'', -- "status"
	tbl_user_activity.tx_hash, -- "transactionId"
	claimed_currency --"ClaimedCurrency"
	
	from tbl_user_activity
	---
	LEFT join tbl_user_activity_ext_origin_fee
	on tbl_user_activity.tx_hash = tbl_user_activity_ext_origin_fee.tx_hash
	---
	where address=in_address
	and coin_name='Celo'

	)

	union
	
	(

	select  tbl_user_activity.activity_type, -- "type"
	address, --- "source"
	tbl_user_activity_ext_origin_fee.origination_fee_in_cusd, --- "originationFeeAmount"
	func_getexchange_rate_cusd_to_x_nearest_past_t(in_currency,tbl_user_activity_ext_origin_fee.origination_fee_in_cusd,tbl_user_activity.block_number) , --- "originationFeeValue"
	--- # # ---
    case --- ---"healthfactor"
          WHEN tbl_user_activity.activity_type = 'liquidate' THEN
               health_factor
          WHEN ((tbl_user_activity.activity_type='borrow' or tbl_user_activity.activity_type='repay') and  (liquidation_price_base <> 0 )) THEN
          		1 / liquidation_price_base 
          else 
    	   	    0
    END ,
	--- # # ---
	amount_of_debt_repaid / NULLIF( tbl_user_activity.amount, 0) ,-- "liquidationPrice" --- 
	amount_of_debt_repaid, -- "amountOfDebtRepaid"
	func_getexchange_rate_cusd_to_x_nearest_past_t(in_currency,amount_of_debt_repaid,tbl_user_activity.block_number), -- "amountOfDebtRepaidValue"
	(tbl_user_activity.amount), --- liquidatorClaimed --
	CASE --- "liquidatorClaimedValue" 
		WHEN claimed_currency is not null then
			func_getexchange_rate_y_to_x_t( tbl_user_activity.claimed_currency , in_currency , tbl_user_activity.amount)
	 END ,
	--(select liquidation_discount from tbl_reserve_configuration where tbl_reserve_configuration.coin_name ='cUSD' order by block_number desc limit 1),--0.0, -- "penaltyPercentage"
	temp_penaltyPercentage, --PenaltyPercentage, 15Aug21
	 coin_name, -- "currency"
	(tbl_user_activity.amount) as out_amount, -- "amount" 
	func_getexchange_rate_cusd_to_x_nearest_past_t(in_currency,tbl_user_activity.amount,tbl_user_activity.block_number), -- "value" 
	date_part('epoch', tbl_user_activity.tx_timestamp) as tx_tmstamp , -- "timestamp"
	'', -- "status"
	tbl_user_activity.tx_hash, -- "transactionId"
	claimed_currency --"ClaimedCurrency" --13Jul21
	
	from tbl_user_activity
	---
	LEFT join tbl_user_activity_ext_origin_fee
	on tbl_user_activity.tx_hash = tbl_user_activity_ext_origin_fee.tx_hash
	---
	where address=in_address
	and coin_name='cUSD'

	)
	
	union
	
	(
	select tbl_user_activity.activity_type, -- type
	address, --- "source"
	tbl_user_activity_ext_origin_fee.origination_fee_in_ceur, --- "originationFeeAmount"
	func_getexchange_rate_ceur_to_x_nearest_past_t(in_currency,tbl_user_activity_ext_origin_fee.origination_fee_in_ceur,tbl_user_activity.block_number), --- "originationFeeValue"
	--- # # ---
    case -- "healthFactor"
          WHEN tbl_user_activity.activity_type = 'liquidate' THEN
               health_factor
          WHEN ((tbl_user_activity.activity_type='borrow' or tbl_user_activity.activity_type='repay') and  (liquidation_price_base <> 0 )) THEN
          		1 / liquidation_price_base 
          else 
          	    0
    END ,
	--- # # ---
	amount_of_debt_repaid / NULLIF( tbl_user_activity.amount, 0) ,-- "liquidationPrice" 
	amount_of_debt_repaid, -- "amountOfDebtRepaid"
	func_getexchange_rate_ceur_to_x_nearest_past_t(in_currency,amount_of_debt_repaid,tbl_user_activity.block_number), -- "amountOfDebtRepaidValue"
	(tbl_user_activity.amount), --- liquidatorClaimed -- same as out_amount/amount in 'liquidate' action/event
	 CASE --- --- liquidatorClaimedValue 
		WHEN claimed_currency is not null then
			func_getexchange_rate_y_to_x_t( tbl_user_activity.claimed_currency , in_currency , tbl_user_activity.amount)
	 END ,
	--(select liquidation_discount from tbl_reserve_configuration where tbl_reserve_configuration.coin_name ='cEUR' order by block_number desc limit 1),--0.0, -- "penaltyPercentage"
	temp_penaltyPercentage, --PenaltyPercentage, 15Aug21
	 coin_name, -- "currency"
	(tbl_user_activity.amount) as out_amount, -- "amount" 
	func_getexchange_rate_ceur_to_x_nearest_past_t(in_currency,tbl_user_activity.amount,tbl_user_activity.block_number), -- "value" 
	date_part('epoch', tbl_user_activity.tx_timestamp) as tx_tmstamp , -- "timestamp"
	'', -- "status"
	tbl_user_activity.tx_hash, -- "transactionId"
	claimed_currency --"ClaimedCurrency" 
	
	from tbl_user_activity
	---
	LEFT join tbl_user_activity_ext_origin_fee
	on tbl_user_activity.tx_hash = tbl_user_activity_ext_origin_fee.tx_hash
	---
	where address=in_address
	and coin_name='cEUR' 

	) order by tx_tmstamp desc offset (in_page_no*in_page_size) limit in_page_size; --- partial Pagination ---

	------------------- Code Ends Here ---------------------
	
END;
$function$
;
