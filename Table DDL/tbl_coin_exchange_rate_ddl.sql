-- public.tbl_coin_exchange_rate definition

-- Drop table

-- DROP TABLE public.tbl_coin_exchange_rate;

CREATE TABLE public.tbl_coin_exchange_rate (
	id_coin_exchange_rate uuid NOT NULL DEFAULT uuid_generate_v1(),
	coin_name varchar(8) NOT NULL,
	network_name varchar(16) NULL,
	usd_exchange_rate numeric NOT NULL,
	cusd_exchange_rate numeric NOT NULL,
	ceuro_exchange_rate numeric NOT NULL,
	celo_exchange_rate numeric NOT NULL,
	block_number int8 NULL,
	agent_id varchar(8) NULL,
	tag varchar(8) NULL,
	ip inet NULL,
	record_comment varchar(32) NULL,
	update_datetime timestamptz NULL,
	creation_datetime timestamptz NULL DEFAULT now(),
	enabled bool NULL DEFAULT true,
	CONSTRAINT tbl_coin_exchange_rate_pkey PRIMARY KEY (id_coin_exchange_rate)
);
CREATE INDEX tbl_coin_exchange_rate_block_number_idx ON public.tbl_coin_exchange_rate USING btree (block_number DESC);
CREATE INDEX tbl_coin_exchange_rate_coin_name_idx ON public.tbl_coin_exchange_rate USING btree (coin_name);

-- Permissions

ALTER TABLE public.tbl_coin_exchange_rate OWNER TO u5p3hgrt8h7nt4;
