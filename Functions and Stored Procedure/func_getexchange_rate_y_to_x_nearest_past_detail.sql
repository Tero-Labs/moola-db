CREATE OR REPLACE FUNCTION public.func_getexchange_rate_y_to_x_nearest_past_detail(in_currency_convert_from_type character varying, in_currency_convert_to_type character varying, in_value numeric, in_block_no numeric)
 RETURNS TABLE(convertedamount numeric, celoexchangerate numeric, cusdexchangerate numeric, ceuroexchangerate numeric, blocknumber numeric, blockdiff numeric, creationdatetime timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
declare
--- Precedence - usd > celo > cusd > ceuro ?
converted_exchange_base_rate numeric:=1;

temp_convertedAmount  numeric;
temp_celoExchangeRate numeric;
temp_cusdExchangeRate numeric;
temp_ceuroExchangeRate numeric;
temp_blockNumber numeric;
temp_blockDiff numeric;
temp_creationDateTime timestamptz;


-- value_out numeric;
BEGIN
	-- Created DateTime 5th June 2021 -  - 
	-- Author: Mohammad Abdur Rahman --
	
	-- Function - 
	
	-- Required Tables -> 
	-- CORE SQL - 
	
	--- Possible Currency Type Strings - 
	---	"cUSD" , "Celo"[X],  "cEUR" 
	
	if in_currency_convert_to_type = 'cUSD' then
	
	    select cusd_exchange_rate,celo_exchange_rate,cusd_exchange_rate into converted_exchange_base_rate,temp_celoExchangeRate,temp_cusdExchangeRate
		from tbl_coin_exchange_rate 
		where coin_name = in_currency_convert_from_type --and enabled=true
		order by abs(block_number - in_block_no) desc limit 1; -- Timeout occurs ???
		--order by block_number desc limit 1;
	
	elseif in_currency_convert_to_type = 'cEUR' then
		
		select ceuro_exchange_rate,celo_exchange_rate,cusd_exchange_rate  into converted_exchange_base_rate,temp_celoExchangeRate,temp_cusdExchangeRate
		from tbl_coin_exchange_rate 
		where coin_name = in_currency_convert_from_type --and enabled=true
		order by abs(block_number - in_block_no) desc limit 1; -- Timeout occurs ???
		--order by block_number desc limit 1;
	
	elseif in_currency_convert_to_type = 'Celo' then
	
		select celo_exchange_rate,celo_exchange_rate,cusd_exchange_rate into converted_exchange_base_rate,temp_celoExchangeRate,temp_cusdExchangeRate
		from tbl_coin_exchange_rate 
		where coin_name = in_currency_convert_from_type --and enabled=true
		order by abs(block_number - in_block_no) desc limit 1; -- Timeout occurs ???
		--order by block_number desc limit 1;
	
		

	end if;
	

	--return converted_exchange_base_rate * in_value;
	temp_convertedAmount = converted_exchange_base_rate * in_value;

	--return QUERY
	select temp_convertedAmount,
		   temp_celoExchangeRate,
		   temp_cusdExchangeRate,
		   temp_ceuroExchangeRate,
		   temp_blockNumber,
		   temp_blockDiff,
		   temp_creationDateTime;

END;
$function$
;
