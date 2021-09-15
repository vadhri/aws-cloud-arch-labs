from troposphere import GetAtt, Join, Output, Parameter, Ref, Template
import troposphere.ec2 as ec2
import troposphere.rds as rds

from troposphere.ec2 import SecurityGroup, SecurityGroupIngress, Route, RouteTable, SubnetRouteTableAssociation, SecurityGroupRule
from troposphere.rds import DBInstance, DBSubnetGroup, DBSecurityGroup

t = Template()

dbname =  Parameter(
        "udacity",
        Default="udacity",
        Description="Primary user database",
        Type="String",
        MinLength="1",
        MaxLength="64",
        AllowedPattern="[a-zA-Z][a-zA-Z0-9]*",
        ConstraintDescription=(
            ""
        ),
    )

allocatedStorage =  Parameter(
        "Storage",
        Default="5",
        Description="Size in GB for the db.",
        Type="Number",
        MinValue="5",
        MaxValue="1024",
        ConstraintDescription="must be between 5 and 1024Gb."
    )


dbinstanceclass = Parameter(
        "DBClass",
        Default="db.t3.micro",
        Description="Database instance class",
        Type="String",
        AllowedValues=[
            "db.t3.micro",
            "db.t3.small",
            "db.t3.medium",
            "db.t3.large",
            "db.t3.xlarge",
            "db.t3.2xlarge",
        ],
        ConstraintDescription="",
    )

masterUsername = Parameter('MasterUsername')
masterUsername.Description = "Master user name for the database."
masterUsername.Type = "String"
masterUsername.Default = "root"

mpass = Parameter('masterPassword')
mpass.Type = "String"
mpass.Description = "Master password for the database."
mpass.NoEcho = True
mpass.Default = "Aqwertyuiop"

paz = Parameter("PrimaryAZ")
paz.Type = "String"
paz.Description = "Primary accessibility zone"
paz.Default = "us-east-1a"


paz2 = Parameter("SecondaryAZ")
paz2.Type = "String"
paz2.Description = "Secondary accessibility zone"
paz2.Default = "us-east-1b"

maz = Parameter(
    "MultiAZ",
    Default="false",
    Description="True or false for multi AZ",
    AllowedValues = [
        "true",
        "false"
    ],
    Type = "String"
)

p = Parameter("PrimaryVpcCIDR")
p.Type = "String"
p.Description="Primary VPC CIDR block"
p.Default = "10.0.0.0/16"

prds = Parameter("PrimaryRDSName")
prds.Type = "String"
prds.Description = "Name of the database"
prds.Default = "udacity"

psubnet = Parameter("PublicSubnet1CIDR")
psubnet.Type = "String"
psubnet.Description = "Public subnet - CIDR block."
psubnet.Default = "10.0.1.0/24"


psubnet2 = Parameter("PublicSubnet2CIDR")
psubnet2.Type = "String"
psubnet2.Description = "Public subnet 2 - CIDR block"
psubnet2.Default = "10.0.2.0/24"

pvtsubnet = Parameter("PrivateSubnet1CIDR")
pvtsubnet.Description = "Private subnet 1 cidr block"
pvtsubnet.Type = "String"
pvtsubnet.Default = "10.0.3.0/24"

pvtsubnet2 = Parameter("PrivateSubnet2CIDR")
pvtsubnet2.Type = "String"
pvtsubnet2.Description = "Private subnet 2 CIDR block"
pvtsubnet2.Default = "10.0.4.0/24"

pvpc = ec2.VPC("Primary")
pvpc.CidrBlock = p.Ref()
pvpc.EnableDnsHostnames = True
pvpc.EnableDnsSupport = True

primary_vpc_subnet = ec2.Subnet("PublicSubnet1")
primary_vpc_subnet.VpcId = pvpc.Ref()
primary_vpc_subnet.CidrBlock=psubnet.Ref()
primary_vpc_subnet.MapPublicIpOnLaunch = True
primary_vpc_subnet.AvailabilityZone = paz.Ref()

primary_vpc_igw = ec2.InternetGateway("IGW")
primary_vpc_igwac = ec2.VPCGatewayAttachment("IGWAC")
primary_vpc_igwac.VpcId = pvpc.Ref()
primary_vpc_igwac.InternetGatewayId = primary_vpc_igw.Ref()

primary_vpc_subnet2 = ec2.Subnet("PubSub2")
primary_vpc_subnet2.VpcId = pvpc.Ref()
primary_vpc_subnet2.CidrBlock=psubnet2.Ref()
primary_vpc_subnet2.MapPublicIpOnLaunch = True
primary_vpc_subnet2.AvailabilityZone = paz2.Ref()

primary_vpc_routetable = ec2.RouteTable("PRT")
primary_vpc_routetable.VpcId = pvpc.Ref()
primary_vpc_routetable.Tags = [{"Key": "Name", "Value": "Public routes"}]

primary_vpc_pvtroutetable = ec2.RouteTable("PriRT")
primary_vpc_pvtroutetable.VpcId = pvpc.Ref()
primary_vpc_pvtroutetable.Tags = [{"Key": "Name", "Value": "Private routes"}]

primary_vpc_publicroute = ec2.Route("PR")
primary_vpc_publicroute.RouteTableId = primary_vpc_routetable.Ref()
primary_vpc_publicroute.DestinationCidrBlock = "0.0.0.0/0"
primary_vpc_publicroute.GatewayId = primary_vpc_igw.Ref()

primary_vpc_public_route_table_assoc1 = SubnetRouteTableAssociation("PSRTA1")
primary_vpc_public_route_table_assoc1.RouteTableId = primary_vpc_routetable.Ref()
primary_vpc_public_route_table_assoc1.SubnetId = primary_vpc_subnet.Ref()

primary_vpc_public_route_table_assoc2 = SubnetRouteTableAssociation("PSRTA2")
primary_vpc_public_route_table_assoc2.RouteTableId = primary_vpc_routetable.Ref()
primary_vpc_public_route_table_assoc2.SubnetId = primary_vpc_subnet2.Ref()

primary_vpc_pvtsubnet1 = ec2.Subnet("PriS1")
primary_vpc_pvtsubnet1.VpcId = pvpc.Ref()
primary_vpc_pvtsubnet1.CidrBlock=pvtsubnet.Ref()
primary_vpc_pvtsubnet1.AvailabilityZone = paz.Ref()

primary_vpc_pvtsubnet2 = ec2.Subnet("PriS2")
primary_vpc_pvtsubnet2.VpcId = pvpc.Ref()
primary_vpc_pvtsubnet2.CidrBlock=pvtsubnet2.Ref()
primary_vpc_pvtsubnet2.AvailabilityZone = paz2.Ref()

pAppSecurityGroupIngress = SecurityGroupRule("ASGI")
pAppSecurityGroupIngress.Description = "SSH from internet"
pAppSecurityGroupIngress.ToPort = 22
pAppSecurityGroupIngress.FromPort = 22 
pAppSecurityGroupIngress.CidrIp = "0.0.0.0/0"
pAppSecurityGroupIngress.IpProtocol  = "tcp"

appSecurityGroup = SecurityGroup("PASG")
appSecurityGroup.SecurityGroupIngress = [pAppSecurityGroupIngress]
appSecurityGroup.GroupDescription = "PASG"
appSecurityGroup.VpcId = pvpc.Ref()

pdbSecurityGroupIngress = SecurityGroupRule("DBSG")
pdbSecurityGroupIngress.Description = "Db port security"
pdbSecurityGroupIngress.ToPort = 3306
pdbSecurityGroupIngress.FromPort = 3306 
pdbSecurityGroupIngress.SourceSecurityGroupId = appSecurityGroup.Ref()
pdbSecurityGroupIngress.IpProtocol  = "tcp"

dbSecurityGroup = SecurityGroup("PDBSG")
dbSecurityGroup.SecurityGroupIngress = [pdbSecurityGroupIngress]
dbSecurityGroup.GroupDescription = "PDBSG"
dbSecurityGroup.VpcId = pvpc.Ref()

dbSubnetGroup = DBSubnetGroup(
        "MyDBSubnetGroup",
        DBSubnetGroupDescription="Subnets available for the RDS DB Instance",
        SubnetIds=[primary_vpc_pvtsubnet1.ref(), primary_vpc_pvtsubnet2.ref()],
    )

prdsdb = rds.DBInstance("PrimaryRdsDB")
prdsdb.DBName = prds.Ref()
prdsdb.Engine = "mysql"
prdsdb.DBInstanceClass = dbinstanceclass.Ref()
prdsdb.DBSubnetGroupName = dbSubnetGroup.Ref()
prdsdb.MasterUsername = masterUsername.Ref()
prdsdb.MasterUserPassword = mpass.Ref()
prdsdb.AllocatedStorage = allocatedStorage.Ref()
prdsdb.VPCSecurityGroups = [dbSecurityGroup.Ref()]
rds
prdsdb.MultiAZ = maz.Ref()

t.add_resource(primary_vpc_subnet)
t.add_resource(primary_vpc_subnet2)
t.add_resource(primary_vpc_pvtsubnet2)
t.add_resource(primary_vpc_pvtsubnet1)

t.add_resource(appSecurityGroup)

t.add_resource(dbSubnetGroup)
t.add_resource(dbSecurityGroup)

t.add_resource(primary_vpc_publicroute)
t.add_resource(primary_vpc_routetable)

t.add_resource(primary_vpc_public_route_table_assoc2)
t.add_resource(primary_vpc_public_route_table_assoc1)

t.add_resource(primary_vpc_pvtroutetable)

# t.add_resource(pAppSecurityGroupIngress)
t.add_resource(primary_vpc_igw)
t.add_resource(primary_vpc_igwac)
# t.add_resource(pdbSecurityGroupIngress)
t.add_resource(pvpc)

t.add_resource(prdsdb)

t.add_parameter(p)
t.add_parameter(allocatedStorage)
t.add_parameter(psubnet)
t.add_parameter(psubnet2)
t.add_parameter(pvtsubnet)
t.add_parameter(pvtsubnet2)

t.add_parameter(paz)
t.add_parameter(paz2)
t.add_parameter(maz)
t.add_parameter(dbname)
t.add_parameter(masterUsername)
t.add_parameter(mpass)
t.add_parameter(dbinstanceclass)

t.add_parameter(prds)

t.add_output(
    Output(
        "VPC",
        Description="Primary vpc", 
        Value=Ref(pvpc)
    )
)

t.add_output(
    Output(
        "AppSecurityGroup",
        Description="App security group.", 
        Value=Ref(appSecurityGroup)
    )
)

t.add_output(
    Output(
        "DBSecurityGroup",
        Description="DB security group.", 
        Value=Ref(dbSecurityGroup)
    )
)

t.add_output(
    Output(
        "PublicSubnets",
        Description="List of public subnets.",
        Value= Join(",", [
                Ref(psubnet),
                Ref(psubnet2)
            ])
    ))

t.add_output(
    Output(
        "PrivateSubnets",
        Description="List of private subnets.",
        Value= Join(", ", [
                Ref(pvtsubnet),
                Ref(pvtsubnet2)
            ])
    ))
    
print(t.to_yaml())
