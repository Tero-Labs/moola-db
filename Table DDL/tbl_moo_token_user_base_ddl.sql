-- public.tbl_moo_token_user_base definition

-- Drop table

-- DROP TABLE public.tbl_moo_token_user_base;

CREATE TABLE public.tbl_moo_token_user_base (
	id_moo_token_user_base uuid NOT NULL DEFAULT uuid_generate_v1(),
	address varchar(65) NOT NULL,
	indx int8 NOT NULL,
	amount varchar(24) NOT NULL,
	proof_array varchar(2048) NOT NULL,
	tag varchar(8) NULL,
	ip inet NULL,
	record_comment varchar(32) NULL,
	update_datetime timestamptz NULL,
	creation_datetime timestamptz NOT NULL DEFAULT now(),
	enabled bool NULL DEFAULT true
);
CREATE UNIQUE INDEX tbl_moo_token_user_base_address_idx ON public.tbl_moo_token_user_base USING btree (address DESC);

-- Permissions

ALTER TABLE public.tbl_moo_token_user_base OWNER TO u5p3hgrt8h7nt4;
GRANT ALL ON TABLE public.tbl_moo_token_user_base TO u5p3hgrt8h7nt4;
