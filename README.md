# Contrat Voting

Le smart Contrat de vote permet à un utilisateur d'organiser un vote ou les élécteurs pourront proposer et voter sur différentes propositions.

Pour débuter il faut :

- Executer node en local.

```shell
npx hardhat node
```
- Deployer le smart contract 
  
```shell
npx hardhat ignition deploy ./ignition/modules/Voting.js
```
Une fois le smart contrat déployé, l'administrateur doit enregistrer l'adresses des utilisateurs voulant voter.
Pour se faire il doit passer par la méthode whitelist() en lui passant en paramétre le tableau d'adresse.

```shell
["address1","address2", "address3",...]
```

Cela fait, les utilisateurs doivent s'enregistrer pour pouvoir participer au vote.
Ils peuvent réaliser cette action en utilisant la méthode regiseteringVoter().

Une fois que toutes les personnes qui le souhaitaient ce sont inscritent au vote, l'administrateur peut passer à l'étape suivante du vote via la méthode ChangeSessionStatus().

Dès lors, tous les utilisateurs qui le désir peuvent faire une ou plusieur propositions qui feront l'objet du vote.
Pour mener à bien cette tâche ils peuvent utiliser la méthode addNewProposal() en lui passant en paramétre une proposition.

```shell
addNewProposal("Diminution du nombre de coup de fouet(refèrence à un film en Egypte)")
```

Une fois que toutes les personnes qui le souhaitaient ont envoyés leur proposition, l'administrateur peut passer à l'étape suivante du vote via la méthode ChangeSessionStatus().

Les utilisateur peuvent consulter les propositions réalisés via la méthode getProposals().
Une fois affiché l'administrateur peut passer à l'étape suivante du vote via la méthode ChangeSessionStatus().

A cette étape les participants peuvent passer au vote des propositions en entrant le numéro de celle qui veulent élir, via la méthode voteOnProposals().
Lorsqu'un utilisateur à fini de voter, il ne peut plus modifier son vote.

```shell
voteOnProposals(0)
```

Quand l'administrateur le décide, il cloture les votent en passant à l'étape suivante du vote via la méthode ChangeSessionStatus().
Cela réalisé il peut afficher le vote gagnant via la méthode getWinningProposal().

Une fois terminé, il faut recharger le contrat pour effectuer de nouveau vote. 








