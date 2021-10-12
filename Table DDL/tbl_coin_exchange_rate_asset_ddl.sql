-- public.tbl_coin_exchange_rate_asset definition

-- Drop table

-- DROP TABLE public.tbl_coin_exchange_rate_asset;

CREATE TABLE public.tbl_coin_exchange_rate_asset (
	id_coin_exchange_rate_asset uuid NOT NULL DEFAULT uuid_generate_v1(),
	source_coin_name varchar(8) NOT NULL,
	source_coin_value numeric NOT NULL,
	network_name varchar(16) NULL,
	destination_coin_name varchar(8) NOT NULL,
	destination_coin_value numeric NOT NULL,
	block_number int8 NULL,
	agent_id varchar(8) NULL,
	tag varchar(8) NULL,
	ip inet NULL,
	record_comment varchar(32) NULL,
	update_datetime timestamptz NULL,
	creation_datetime timestamptz NULL DEFAULT now(),
	enabled bool NULL DEFAULT true,
	CONSTRAINT tbl_coin_exchange_rate_asset_pkey PRIMARY KEY (id_coin_exchange_rate_asset)
);

-- Permissions

ALTER TABLE public.tbl_coin_exchange_rate_asset OWNER TO u5p3hgrt8h7nt4;
GRANT ALL ON TABLE public.tbl_coin_exchange_rate_asset TO u5p3hgrt8h7nt4;