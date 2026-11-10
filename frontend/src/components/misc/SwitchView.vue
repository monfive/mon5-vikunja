<template>
	<component
		:is="is"
		class="switch-view"
	>
		<slot />
	</component>
</template>

<script setup lang="ts">
import type {Component} from 'vue'

withDefaults(defineProps<{
	is?: string | Component,
}>(), {
	is: 'div',
})
</script>

<style lang="scss" scoped>
.switch-view {
	background: var(--switch-view-track);
	display: inline-flex;
	gap: 2px;
	border-radius: $radius-medium;
	font-size: .8125rem;
	font-weight: 600;
	padding: 3px;
}

::v-slotted(.switch-view-button) {
	display: flex;
	align-items: center;
	block-size: 32px;
	padding: 0 .75rem;
	white-space: nowrap;
	border-radius: 7px;
	color: var(--grey-700);
	transition: all 100ms;

	&:hover {
		color: var(--text-strong);
		background: hsla(var(--grey-100-hsl), .6);
	}

	&.is-active {
		color: var(--switch-view-color);
		background: var(--switch-view-active-background);
		box-shadow: var(--shadow-sm);
	}
}
</style>
