go
create procedure use_backup @Path varchar(1000), @Path_to varchar(1000)
as
begin
	restore database User_Actions
	from disk = @Path
	with replace
	move 'User_Actions' to @Path_to
end
go

exec use_backup 'D:\sql\User_Actions.bak' 'D:\sql\User_Actions.mdf' --Путь до файла бекапа