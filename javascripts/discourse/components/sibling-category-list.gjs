import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import SubCategoryItem from "discourse/components/sub-category-item";
import i18n from 'discourse-common/helpers/i18n';

export default class SiblingCategoryList extends Component {
  @service router;

  @tracked parentCategory = null;

  willDestroy() {
    super.willDestroy(...arguments);
    this.parentCategory = null;
  }

  get shouldShowBlock() {
    const currentRoute = this.router.currentRoute;

    if (!currentRoute.attributes?.category) {
      return false;
    }

    const category = currentRoute.attributes.category;
    if (category.parentCategory) {
      this.parentCategory = category.parentCategory;
      if (this.parentCategory.subcategories && this.shouldDisplay(this.parentCategory.id)) {
        return true;
      }
    }
    return false;
  }

  shouldDisplay(parentCategoryId) {
    const displayInCategories = this.args?.params?.displayInCategories
      ?.split(",")
      .map(Number);

    return (
      displayInCategories === undefined ||
      displayInCategories.includes(parentCategoryId)
    );
  }

  <template>
    {{#if this.shouldShowBlock}}
      <h3 class="subcategory-list--heading">
        {{i18n (themePrefix "sibling_category_list.heading")}}
      </h3>

      <div class="subcategory-list--items">
        {{#each this.parentCategory.subcategories as |subcat|}}
          <div class="subcategory-list--item">
            <SubCategoryItem @category={{subcat}} />
          </div>
        {{/each}}
      </div>
    {{/if}}
  </template>

}