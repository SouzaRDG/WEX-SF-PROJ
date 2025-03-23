import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveRecords from '@salesforce/apex/ProjectCreatorAssistantController.saveRecords';

export default class projectCreatorAssistant extends LightningElement {
    @track projectName = '';
    @track milestones = [];
    @track isLoading = false;

    handleProjectNameChange(event) {
        this.projectName = event.target.value;
    }

    handleMilestoneChange(event) {
        const milestoneId = event.target.dataset.id;
        this.milestones = this.milestones.map(milestone =>
            milestone.id === milestoneId
                ? { ...milestone, name: event.target.value }
                : milestone
        );
    }

    handleTaskChange(event) {
        const milestoneId = event.target.dataset.milestoneId;
        const taskId = event.target.dataset.id;
        this.milestones = this.milestones.map(milestone => {
            if (milestone.id === milestoneId) {
                milestone.tasks = milestone.tasks.map(task =>
                    task.id === taskId
                        ? { ...task, name: event.target.value }
                        : task
                );
            }
            return milestone;
        });
    }

    addMilestone() {
        this.milestones = [
            ...this.milestones,
            { id: Date.now().toString(), name: '', tasks: [] }
        ];
    }

    addTask(event) {
        const milestoneId = event.target.dataset.id;
        this.milestones = this.milestones.map(milestone => {
            if (milestone.id === milestoneId) {
                milestone.tasks = [
                    ...milestone.tasks,
                    { id: Date.now().toString(), name: '' }
                ];
            }
            return milestone;
        });
    }

    removeMilestone(event) {
        const milestoneId = event.target.dataset.id;
        this.milestones = this.milestones.filter(milestone => milestone.id !== milestoneId);
    }

    removeTask(event) {
        const milestoneId = event.target.dataset.milestoneId;
        const taskId = event.target.dataset.id;
        this.milestones = this.milestones.map(milestone => {
            if (milestone.id === milestoneId) {
                milestone.tasks = milestone.tasks.filter(task => task.id !== taskId);
            }
            return milestone;
        });
    }

    saveProject() {
        this.isLoading = true;

        if (!this.projectName.trim()) {
            const toastEvent = new ShowToastEvent({
                title: 'Validation Error',
                message: 'Project name is required.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
            return;
        }
        const invalidMilestones = this.milestones.some(milestone => !milestone.name.trim());
        const invalidTasks = this.milestones.some(milestone =>
            milestone.tasks.some(task => !task.name.trim())
        );
        if (invalidMilestones || invalidTasks) {
            const toastEvent = new ShowToastEvent({
                title: 'Validation Error',
                message: 'All milestones and their tasks must have names.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
            return;
        }    
        const data = {
            projectName: this.projectName,
            milestones: this.milestones
        };
        saveRecords({ data: JSON.stringify(data) })
            .then(() => {
                const event = new ShowToastEvent({
                    title: 'Success!',
                    message: 'The operation completed successfully.',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Something went wrong.',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            });
            this.isLoading = false;
    }
}