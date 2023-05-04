create database delivery;

use delivery;

create table tb_lanchonete(
CNPJ int(15) primary key not null,
NomeFantasia varchar(30) not null,
RazaoSocial varchar(50) not null
);

create table tb_estoque(
CodProduto int primary key auto_increment not null,
Descricao varchar(20) not null,
Marca varchar(20) not null,
Valor float(10) not null,
Quantidade int not null
);

create table tb_entregador(
CodEntregador int primary key auto_increment not null,
Nome varchar(50) not null,
Telefone varchar(11) not null,
CPF int(11) not null
);

create table tb_veiculo(
CodVeiculo int (10) primary key not null,
CodEntregador int,
TipoVeiculo varchar(20) not null,
PlacaVeiculo varchar(7),
Cor varchar(20),

foreign key (CodEntregador) references tb_entregador (CodEntregador)
);

create table tb_cliente(
CodCliente int primary key auto_increment not null,
Nome varchar(50) not null,
CPF int(11) not null,
CEP int(8) not null,
Bairro varchar(20) not null,
Cidade varchar(20) not null,
Estado varchar(20) not null,
Telefone varchar(11) not null
);

create table tb_pedido(
CodPedido int primary key auto_increment not null,
CodCliente int,
Referencia int,
Descricao varchar(20),
Preco float(10),
Quantidade int,

foreign key (CodCliente) references tb_cliente (CodCliente)
);

select * from tb_lanchonete;
select * from tb_estoque;
select * from tb_cliente;
select * from tb_entregador;
select * from tb_veiculo;
select * from tb_pedido;


<!-- CRIANDO E CHAMANDO OS TRIGGER'S -->

delimiter $
create trigger Tgr_Pedido_Insert before insert
on tb_pedido
for each row
begin
update tb_estoque set Quantidade = Quantidade - new.Quantidade
where CodProduto = new.Referencia;
End$

create trigger Tgr_Pedido_Delete before delete
on tb_pedido
for each row
begin update tb_estoque set Quantidade = Quantidade + old.Quantidade
where CodProduto = old.Referencia;
End$
delimiter $


insert into tb_pedido (CodCliente,Referencia,Descricao,Preco,Quantidade) 
values (3,1,"Carne",4.2,4),
	   (2,2,"Queijo",2.4,2),
       (1,1,"Carne",4.2,5);;

delete from tb_pedido where CodPedido=1;

<!-- CRIANDO E CHAMANDO A VIEW -->

create view viewpedido as select CodPedido, CodCliente, Descricao, Preco, Quantidade, Preco*Quantidade as Total from tb_pedido;

select * from viewpedido;

<!-- CRIANDO E CHAMANDO O PROCEDURE -->

delimiter $$
create procedure EscolherPedidos(in Quantidade int)
begin
select * from tb_pedido
limit 0,3;
end $$
delimiter ;

call EscolherPedidos(1);
