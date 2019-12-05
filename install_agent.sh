#!/bin/bash
echo "starting script"

while [ ! ${finished} ]
echo "Node name just only use (0-9 a-z A-Z _-.)"
echo -n "Input node name and press (ENTER): "
read node
char='0-9a-zA-Z_-.'
do
	if [[ ! $node =~ [^$char] ]];
		then
			echo "Download agent.."
			sudo mkdir /opt/agent
			wget https://s3-ap-southeast-1.amazonaws.com/ketitik/jeager-node-monitoring/agent/agent_romanova_linux_arm7.tar.gz -P /opt/agent/

			echo ""
			echo "Configure agent.."
			echo "Node Name: $node"
			sudo tar -xvf /opt/agent/agent_romanova_linux_arm7.tar.gz -C /opt/agent/			
			sudo cp /opt/agent/_bin/agent.yaml.example /opt/agent/_bin/agent.yaml
			cd /opt/agent/_bin && sed -i "s/<var-1>/$node/g" agent.yaml
			sudo sed -i "s/<var-2>/35.187.228.75:9092/g" /opt/agent/_bin/agent.yaml
			sudo sed -i "s/<var-3>/raisaadriana/g" /opt/agent/_bin/agent.yaml
			sudo sed -i "s/<var-4>/6Juni1990/g" /opt/agent/_bin/agent.yaml
			sudo sed -i "s/<var-5>/jeager.node.monitoring/g" /opt/agent/_bin/agent.yaml

			sudo rm /opt/agent/_bin/agent.yaml.example
			sudo rm /opt/agent/agent_romanova_linux_arm7.tar.gz

			cd /opt/agent/_bin && sudo chmod +x agent_romanova_linux_arm7
			sudo sed -i '2i\cd /opt/agent/_bin' /etc/rc.local
			sudo sed -i '3i\nohup ./agent_romanova_linux_arm7 > agent.log &' /etc/rc.local

			echo ""
			echo "Agent will be run after reboot system"
			echo -n "Would you like to reboot? y/n? "
			read reply

			if [ "$reply" = y -o "$reply" = Y ]
			then
			   	reboot
			   	exit 0
			else
				echo ""
				echo "All is done"
				echo "After Reboot agent will be started"
			   	exit 0
			fi

		else
			echo ""
			echo "Caution!!"
			echo "Make ure Node name and try Enter Node name"
			echo "Node name just only use (0-9 a-z A-Z _-.)"
			echo ""
	fi
done
