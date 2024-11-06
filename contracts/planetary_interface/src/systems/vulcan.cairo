use starknet::{ContractAddress};

#[starknet::interface]
trait IVulcan<T> {
    fn live_long(self: @T) -> felt252;
}

#[dojo::contract(namespace: "vulcan")]
mod salute {
    use super::IVulcan;
    use debug::PrintTrait;
    use core::traits::Into;
    use starknet::{ContractAddress, get_contract_address, get_caller_address, get_tx_info};
    
    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
    };
    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait,
    };
    use planetary_interface::utils::misc::{WORLD};

    fn dojo_init(ref self: ContractState) {
        let world = self.world(@"vulcan");
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.dispatcher().register(VulcanInterfaceTrait::NAMESPACE, world.dispatcher.contract_address);
    }

    #[abi(embed_v0)]
    impl IVulcanImpl of IVulcan<ContractState> {

        // salute
        fn live_long(self: @ContractState) -> felt252 {
            ('and_prosper')
        }
    }
}
