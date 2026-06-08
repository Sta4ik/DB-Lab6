go
create procedure use_backup @Path varchar(1000)
as
begin
	restore database User_Actions
	from disk = @Path
	with replace
end
go

exec use_backup 'D:\sql\User_Actions.bak' --Путь до файла бекапа
