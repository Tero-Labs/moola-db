-- public.tbl_user_activity_ext_origin_fee definition

-- Drop table

-- DROP TABLE public.tbl_user_activity_ext_origin_fee;

CREATE TABLE public.tbl_user_activity_ext_origin_fee (
	id_user_activity_ext_origin_fee uuid NOT NULL DEFAULT uuid_generate_v1(),
	activity_type varchar(16) NULL,
	origination_fee_in_celo numeric NULL,
	origination_fee_in_cusd numeric NULL,
	origination_fee_in_ceur numeric NULL,
	tx_hash varchar(64) NOT NULL,
	tx_timestamp timestamp NULL,
	block_number int8 NOT NULL,
	agent_id varchar(8) NULL,
	tag varchar(8) NULL,
	ip inet NULL,
	record_comment varchar(32) NULL,
	update_datetime timestamptz NULL,
	creation_datetime timestamptz NULL DEFAULT now(),
	enabled bool NULL DEFAULT true,
	CONSTRAINT tbl_user_activity_ext_origin_fee_pk PRIMARY KEY (id_user_activity_ext_origin_fee),
	CONSTRAINT tbl_user_activity_ext_origin_fee_un UNIQUE (tx_hash)
);
CREATE UNIQUE INDEX tbl_user_activity_ext_origin_fee_tx_hash_idx ON public.tbl_user_activity_ext_origin_fee USING btree (tx_hash DESC);

-- Permissions

ALTER TABLE public.tbl_user_activity_ext_origin_fee OWNER TO u5p3hgrt8h7nt4;
GRANT ALL ON TABLE public.tbl_user_activity_ext_origin_fee TO u5p3hgrt8h7nt4;
