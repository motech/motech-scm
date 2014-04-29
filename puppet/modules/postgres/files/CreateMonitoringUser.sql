create role nagiosuser;
alter role nagiosuser NOCREATEDB;
alter role nagiosuser NOCREATEUSER;
alter role nagiosuser NOCREATEROLE;
alter role nagiosuser NOREPLICATION;
alter role nagiosuser NOSUPERUSER;
alter role nagiosuser LOGIN;
alter role nagiosuser with password 'password';
