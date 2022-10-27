-- truncate table [m_dbtypes];
-- truncate table [m_employee];

insert into [m_dbtypes] ([n1], [n2], [n3], [n4], [n5], [n6], [n7], [n8], [n9], [f1], [f2], [d1], [d2], [d3], [d4], [d5], [d6], [s1], [s2], [s3], [u1], [u2], [u3], [b1], [b2], [o4]) VALUES 
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 0.1, 0.2, '2001-01-01', '2002-02-02', '2003-03-03', '2004-04-04', '2005-05-05', '2006-06-06', 'c', 'v', 't', N'c', N'v', N't', 0xbb, 0xbbbb, newid());
insert into [m_employee] ([name], [address], [gender], [retired], [birthday], [internal_id], [created_by], [created_on], [updated_by], [updated_on], [version]) VALUES 
    (N'v', null, null, 2, '2003-03-03', null, 'system', getdate(), 'system', getdate(), null);
