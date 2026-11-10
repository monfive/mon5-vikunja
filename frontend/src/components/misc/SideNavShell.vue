<template>
	<div class="content-widescreen">
		<div class="side-nav-shell">
			<nav class="navigation">
				<ul>
					<li
						v-for="(item, index) in navigationItems"
						:key="`nav-${index}`"
					>
						<RouterLink
							v-slot="{href, navigate, isActive, isExactActive}"
							:to="{name: item.routeName}"
							custom
						>
							<a
								:href="href"
								class="navigation-link"
								:class="{'is-active': (exact ? isExactActive : isActive) || isAliasActive(item)}"
								@click="navigate"
							>
								{{ item.title }}
							</a>
						</RouterLink>
					</li>
					<li
						v-for="({url, text}, index) in extraLinks"
						:key="`extra-${index}`"
					>
						<BaseButton
							class="navigation-link is-flex is-align-items-center"
							:href="url"
						>
							<span>
								{{ text }}
							</span>
							<span class="ml-1 has-text-grey-light is-size-7">
								<Icon
									icon="arrow-up-right-from-square"
								/>
							</span>
						</BaseButton>
					</li>
				</ul>
			</nav>
			<section class="view">
				<RouterView />
			</section>
		</div>
	</div>
</template>

<script setup lang="ts">
import {useRoute} from 'vue-router'

import BaseButton from '@/components/base/BaseButton.vue'

export interface SideNavItem {
	title: string
	routeName: string
	activeRouteNames?: string[]
}

export interface SideNavExtraLink {
	url: string
	text: string
}

withDefaults(defineProps<{
	navigationItems: SideNavItem[]
	extraLinks?: SideNavExtraLink[]
	exact?: boolean
}>(), {
	extraLinks: () => [],
	exact: false,
})

const route = useRoute()

function isAliasActive(item: SideNavItem) {
	return item.activeRouteNames?.includes(route.name as string) ?? false
}
</script>

<style lang="scss" scoped>
.side-nav-shell {
	display: flex;
	align-items: flex-start;
	gap: 1.5rem;

	@media screen and (max-width: $tablet) {
		flex-direction: column;
	}
}

.navigation {
	inline-size: 25%;
	padding: .5rem;
	background: var(--white);
	border: 1px solid var(--border-light);
	border-radius: $radius-large;
	font-size: .875rem;
	font-weight: 500;

	@media screen and (max-width: $tablet) {
		inline-size: 100%;
		padding-inline-start: 0;
	}
}

.navigation-link {
	display: flex;
	align-items: center;
	min-block-size: 36px;
	padding: 0 .625rem;
	color: var(--grey-700);
	inline-size: 100%;
	border-radius: $radius;

	&:hover {
		background: var(--grey-100);
		color: var(--text-strong);
	}

	&.is-active {
		background: hsla(var(--primary-hsl), .1);
		color: var(--primary);
		font-weight: 600;
	}
}

.view {
	inline-size: 75%;
	min-inline-size: 0;

	@media screen and (max-width: $tablet) {
		inline-size: 100%;
		padding-inline-start: 0;
		padding-block-start: 1rem;
	}
}
</style>
