impl PlayerIntrospect<> of dojo::model::introspect::Introspect<Player<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1688967236292208983193080276451500633770839573326905388937393665850959267787,
                    layout: dojo::model::introspect::Introspect::<Array<u32>>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'Player',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'player',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'games',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::Array(
                            array![dojo::model::introspect::Introspect::<u32>::ty()].span()
                        )
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct PlayerEntity {
    __id: felt252, // private field
    pub games: Array<u32>,
}

#[generate_trait]
pub impl PlayerEntityStoreImpl of PlayerEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> PlayerEntity {
        PlayerModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @PlayerEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<PlayerEntity>::update_entity(self, world);
    }

    fn delete(self: @PlayerEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<PlayerEntity>::delete_entity(self, world);
    }


    fn get_games(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<u32> {
        let mut values = dojo::model::ModelEntity::<
            PlayerEntity
        >::get_member(
            world,
            entity_id,
            1688967236292208983193080276451500633770839573326905388937393665850959267787
        );
        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `Player::games`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_games(self: @PlayerEntity, world: dojo::world::IWorldDispatcher, value: Array<u32>) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1688967236292208983193080276451500633770839573326905388937393665850959267787,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl PlayerStoreImpl of PlayerStore {
    fn entity_id_from_keys(player: ContractAddress) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@player, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Player {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Player>::deserialize(ref serialized);

        if core::option::OptionTrait::<Player>::is_none(@entity) {
            panic!(
                "Model `Player`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Player>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, player: ContractAddress) -> Player {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@player, ref serialized);

        dojo::model::Model::<Player>::get(world, serialized.span())
    }

    fn set(self: @Player, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Player>::set_model(self, world);
    }

    fn delete(self: @Player, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Player>::delete_model(self, world);
    }


    fn get_games(world: dojo::world::IWorldDispatcher, player: ContractAddress) -> Array<u32> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@player, ref serialized);

        let mut values = dojo::model::Model::<
            Player
        >::get_member(
            world,
            serialized.span(),
            1688967236292208983193080276451500633770839573326905388937393665850959267787
        );

        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `Player::games`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_games(self: @Player, world: dojo::world::IWorldDispatcher, value: Array<u32>) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1688967236292208983193080276451500633770839573326905388937393665850959267787,
                serialized.span()
            );
    }
}

pub impl PlayerModelEntityImpl of dojo::model::ModelEntity<PlayerEntity> {
    fn id(self: @PlayerEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @PlayerEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.games, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> PlayerEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<PlayerEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<PlayerEntity>::is_none(@entity_values) {
            panic!("ModelEntity `PlayerEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<PlayerEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> PlayerEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Player>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @PlayerEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Player>::layout()
        );
    }

    fn delete_entity(self: @PlayerEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Player>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Player>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Player>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @PlayerEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Player>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Player>::selector(),
                    dojo::model::ModelIndex::MemberId((self.id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }
}

#[cfg(target: "test")]
pub impl PlayerModelEntityTestImpl of dojo::model::ModelEntityTest<PlayerEntity> {
    fn update_test(self: @PlayerEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Player>::layout()
        );
    }

    fn delete_test(self: @PlayerEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Player>::layout()
        );
    }
}

pub impl PlayerModelImpl of dojo::model::Model<Player> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Player {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        PlayerStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Player, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Player, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(Self::keys(self)), Self::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, keys: Span<felt252>, member_id: felt252
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                let entity_id = dojo::utils::entity_id_from_keys(keys);
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @Player,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>
    ) {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((self.entity_id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "Player"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-Player"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        159543693189590805658275994755459126376428058455876231708232088621283527711
    }

    #[inline(always)]
    fn instance_selector(self: @Player) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1073075359926275415180704315933677548333097210683379121732618306925003101845
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @Player) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Player) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.player, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Player) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.games, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Player>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Player) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl PlayerModelTestImpl of dojo::model::ModelTest<Player> {
    fn set_test(self: @Player, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Player>::keys(self)),
            dojo::model::Model::<Player>::values(self),
            dojo::model::Model::<Player>::layout()
        );
    }

    fn delete_test(self: @Player, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Player>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Player>::keys(self)),
            dojo::model::Model::<Player>::layout()
        );
    }
}

#[starknet::interface]
pub trait Iplayer<T> {
    fn ensure_abi(self: @T, model: Player);
}

#[starknet::contract]
pub mod player {
    use super::Player;
    use super::Iplayer;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Player>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Player>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Player>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Player>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Player>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Player>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Player>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Player>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Player>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Player>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Player>::ty()
        }
    }

    #[abi(embed_v0)]
    impl playerImpl of Iplayer<ContractState> {
        fn ensure_abi(self: @ContractState, model: Player) {}
    }
}
