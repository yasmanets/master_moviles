import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CurriculumPage } from './curriculum.page';

describe('CurriculumPage', () => {
  let component: CurriculumPage;
  let fixture: ComponentFixture<CurriculumPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CurriculumPage ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CurriculumPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
