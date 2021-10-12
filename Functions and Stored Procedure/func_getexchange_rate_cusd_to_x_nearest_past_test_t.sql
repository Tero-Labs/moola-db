CREATE OR REPLACE FUNCTION public.func_getexchange_rate_cusd_to_x_nearest_past_test_t(in_currency_convert_to_type character varying, in_value numeric, in_block_no numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
--- Precedence - usd > celo > cusd > ceuro ?
converted_exchange_base_rate numeric:=1;
-- value_out numeric;
BEGIN
	-- Created DateTime 5th June 2021 -  - 
	-- Author: Mohammad Abdur Rahman --
	
	-- Function - 
	
	-- Required Tables -> 
	-- CORE SQL - 
	
	--- Possible Currency Type Strings - 
	---	"cUSD" , "Celo"[X],  "cEUR" 
	
	--if in_currency_convert_to_type = 'Celo' then
	
	    --select celo_exchange_rate into converted_exchange_base_rate
		--from tbl_coin_exchange_rate 
		--where coin_name = 'cUSD' --and enabled=true
		--order by abs(block_number - in_block_no) desc limit 1; -- Timeout occurs ???
		----order by block_number desc limit 1;
	
	--elseif in_currency_convert_to_type = 'cEUR' then
		
		--select ceuro_exchange_rate into converted_exchange_base_rate
		--from tbl_coin_exchange_rate 
		--where coin_name = 'cUSD' --and enabled=true
		--order by abs(block_number - in_block_no) desc limit 1; -- Timeout occurs ???
		----order by block_number desc limit 1;
	
	--elseif in_currency_convert_to_type = 'cUSD' then
		
		--converted_exchange_base_rate := 1;
	
	--end if;


     
    ----- 22th September 2021,Wednesday 2021 ---
	select destination_coin_value into converted_exchange_base_rate
	from tbl_coin_exchange_rate_asset 
	where source_coin_name      = 'cUSD' 
	and   destination_coin_name = in_currency_convert_to_type
	order by abs(block_number - in_block_no) desc limit 1; --- Timeout occurs ??
	--order by block_number desc limit 1;
    -- and enabled=true

   --- May need handle for inquoted in/out currency ??? -- use EXISTS 

	
	return converted_exchange_base_rate * in_value;
	
END;
$function$
;
